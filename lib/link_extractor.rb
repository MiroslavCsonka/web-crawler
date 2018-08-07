# frozen_string_literal: true

require 'nokogiri'

class LinkExtractor
  def initialize(response, logger: Logger.new(STDOUT))
    @response = response
    @logger = logger
  end

  def internal_links
    page = Nokogiri::HTML(response.body)
    page.css('a')
        .select { |link| internal?(link) }
        .map { |l| l['href'].to_s }
        .map { |link| include_hostname(link) }
  end

  private

  attr_reader :response, :logger

  def internal?(link)
    hostname = URI(response.effective_url).host
    link['href']&.start_with?('/', "https://#{hostname}", "http://#{hostname}")
  end

  def include_hostname(path_or_url)
    parsed_effective_url = URI(response.effective_url)
    uri = URI(path_or_url)
    uri.path = (parsed_effective_url.path.end_with?('/') && !uri.path.end_with?('/') ? "#{uri.path}/" : uri.path)
    uri.scheme ||= parsed_effective_url.scheme
    uri.host ||= parsed_effective_url.host
    uri.to_s
  rescue URI::InvalidURIError
    logger.error("Path or URL: #{path_or_url.inspect} contains non ascii characters")
  end
end
