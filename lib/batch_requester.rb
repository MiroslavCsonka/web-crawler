# frozen_string_literal: true

require 'typhoeus'

class BatchRequester
  class << self
    def fetch(links)
      batch_queue = Typhoeus::Hydra.new
      requests = links.map do |url|
        request = Typhoeus::Request.new(url, method: :get, followlocation: true)
        batch_queue.queue(request)
        request
      end
      batch_queue.run
      requests
    end
  end
end
