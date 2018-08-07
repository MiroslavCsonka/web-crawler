# frozen_string_literal: true

require 'spec_helper'
require 'english'

RSpec.describe 'Integration test' do
  context "'when --url params isn' specified'" do
    let(:successful_command) { 'bin/web_crawler' }

    it 'provides a help on how to run the command' do
      expect(`#{successful_command}`).to include('Usage:')
    end

    it 'returns 0 as exit code' do
      `#{successful_command}`

      expect($CHILD_STATUS.exitstatus).to eq(1)
    end
  end

  context 'when all required parameters are specified' do
    let(:successful_command) { 'bin/web_crawler -u http://example.com/' }

    it 'returns number of internal links' do
      expect(`#{successful_command}`).to eq(
        'Working pages:
+---------------------+------------------+----------------------------------------+
| Url                 | HTTP status code | Number of internal pages it references |
+---------------------+------------------+----------------------------------------+
| http://example.com/ | 200              | 0                                      |
+---------------------+------------------+----------------------------------------+
Pages to investigate
+-----+------------------+------------------------+
| Url | HTTP status code | Pages that point to it |
+-----+------------------+------------------------+
+-----+------------------+------------------------+
'
      )
    end

    it 'returns 0 as exit code' do
      `#{successful_command}`

      expect($CHILD_STATUS).to eq(0)
    end
  end
end
