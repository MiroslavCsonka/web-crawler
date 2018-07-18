# frozen_string_literal: true

require 'spec_helper'
require 'restclient'

RSpec.describe 'Integration test' do
  context "'when --url params isn' specified'" do
    let(:successful_command) { 'bin/web_scraper' }

    it 'provides a help on how to run the command' do
      expect(`#{successful_command}`).to include('Usage:')
    end

    it 'returns 0 as exit code' do
      `#{successful_command}`

      expect($CHILD_STATUS.exitstatus).to eq(1)
    end
  end

  context 'when all required parameters are specified' do
    let(:successful_command) { 'bin/web_scraper -u https://monzo.com' }

    it 'returns number of internal links' do
      expect(`#{successful_command}`).to eq("Page contains 28 internal links\n")
    end

    it 'returns 0 as exit code' do
      `#{successful_command}`

      expect($CHILD_STATUS.exitstatus).to eq(0)
    end
  end
end
