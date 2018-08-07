# frozen_string_literal: true

require 'spec_helper'
require 'lib/command_line_config_parser'

RSpec.describe CommandLineConfigParser do
  let(:arguments) { [] }

  describe '#parse' do
    subject(:parse) { described_class.new(arguments).parse }

    context 'when all required params are present' do
      let(:arguments) { %w[--url https://www.some-website.com] }

      it 'parses our the url' do
        expect(parse.fetch(:url)).to eq('https://www.some-website.com')
      end
    end

    context 'when the url is not valid' do
      let(:arguments) { %w[--url 42] }

      it 'raises an error' do
        expect { parse }.to raise_error(CommandLineConfigParser::InvalidURLError)
      end
    end

    context 'when the url is not present' do
      let(:arguments) { [] }
      it 'raises an error' do
        expect { parse }.to raise_error(CommandLineConfigParser::MissingURLError)
      end
    end
  end
end
