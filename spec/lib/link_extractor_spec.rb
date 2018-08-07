# frozen_string_literal: true

require 'spec_helper'
require 'lib/link_extractor'

RSpec.describe LinkExtractor do
  Response = Struct.new(:effective_url, :body)

  let(:response) { Response.new(effective_url, body) }
  let(:effective_url) { 'https://monzo.com' }
  describe '#internal_links' do
    subject(:internal_links) { described_class.new(response).internal_links }

    context 'when the links are absolute' do
      let(:body) do
        "<a href='/some/path?query=1#fragment/'>"
      end
      it 'it fills in the hostname and scheme' do
        expect(internal_links).to eq(['https://monzo.com/some/path?query=1#fragment/'])
      end
    end

    context 'when the link does not end with backslash' do
      context 'when and effective URL does' do
        it 'includes it'
      end
    end

    context 'when the link is pointing to subdomain' do
      it 'skips it'
    end

    context 'when the link contains non ascii characters' do
      it 'logs the error'
    end

    context 'when the page contains external links' do
      it 'skips them'
    end
  end
end
