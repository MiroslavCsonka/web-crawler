# frozen_string_literal: true

require 'pstore'
require 'lib/batch_requester'
require 'lib/link_extractor'

class WebCrawler
  def initialize(starting_point, pstore:, logger: Logger.new(STDOUT))
    @starting_point = starting_point
    @logger = logger
    @store = pstore
  end

  def run
    store.transaction do
      store[:pages] ||= {}
      store[:visited] ||= {}
      store[:to_visit] ||= Set.new([starting_point])

      scrape_batch until store[:to_visit].empty?

      store.commit
    end

    store.transaction { store[:visited] }
  end

  private

  def scrape_batch
    logger.info("Going into visit #{store[:to_visit].length} pages")

    requests = BatchRequester.fetch(store[:to_visit])

    results_of_visit = requests.map { |request| extract_from_request(request) }

    persist_result(results_of_visit)
  end

  def extract_from_request(request)
    links = if request.response.success?
              LinkExtractor.new(request.response, logger: logger).internal_links.tap do |internal_links|
                logger.debug("Page #{request.response.effective_url} contains #{internal_links.length} internal links")
              end
            end

    {
        effective_url: request.response.effective_url,
        status: request.response.code,
        references: links
    }
  end

  def persist_result(results_of_visit)
    results_of_visit.each do |result_of_visit|
      store[:visited][result_of_visit.fetch(:effective_url)] = result_of_visit
    end
    discovered_urls = results_of_visit.map {|result_of_visit| result_of_visit.fetch(:references).to_a}.flatten
    store[:to_visit] = Set.new(discovered_urls - store[:visited].keys)
  end

  attr_reader :starting_point, :store, :logger
end
