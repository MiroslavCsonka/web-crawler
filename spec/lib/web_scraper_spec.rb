# frozen_string_literal: true

require 'spec_helper'
require 'lib/web_crawler'

RSpec.describe WebCrawler do
  let(:pstore) { PStore.new('tmp/data_test.pstore', thread_safe: true) }
  let(:starting_url) { 'https://b-social.com' }

  subject(:web_crawler) { described_class.new(starting_url, pstore: pstore) }

  after do
    File.delete('tmp/data_test.pstore')
  rescue StandardError
    nil
  end

  describe '#run' do
    let(:sample_response) do
      instance_double(
        Typhoeus::Response,
        success?: true,
        effective_url: starting_url,
        body: '<a href="/some-url">We are hiring!</a>',
        code: 200
      )
    end
    it 'delegates requesting to BatchRequester' do
      allow(BatchRequester).to receive(:fetch).and_return([])
      expect(BatchRequester).to receive(:fetch).with([starting_url])

      web_crawler.run
    end

    it 'delegates extracting links for every visited page' do
      response = instance_double(Typhoeus::Response, success?: true, effective_url: starting_url, body: '', code: 200)
      request = instance_double(Typhoeus::Request, response: response)
      allow(BatchRequester).to receive(:fetch).and_return([request])

      expect_any_instance_of(LinkExtractor).to receive(:internal_links).once.and_call_original

      web_crawler.run
    end

    it 'returns the right structure' do
      request = instance_double(Typhoeus::Request, response: sample_response)
      allow(BatchRequester).to receive(:fetch).and_return([])
      allow(BatchRequester).to receive(:fetch).with([starting_url]).and_return([request])

      expect(web_crawler.run).to eq(
        'https://b-social.com' => {
          effective_url: 'https://b-social.com',
          status: 200,
          references: ['https://b-social.com/some-url']
        }
      )
    end

    it 'does not visit the same page twice'
  end
end
