require 'spec_helper'

RSpec.describe "Integration test" do
  context "'when --url params isn' specified'" do
    let(:successful_command) { "bin/web_scraper" }

    it "provides a help on how to run the command" do
      expect(%x(#{successful_command})).to include("Usage:")
    end

    it "returns 0 as exit code" do
      %x(#{successful_command})

      expect($?.exitstatus).to eq(1)
    end

  end

  context "when all required parameters are specified" do
    let(:successful_command) { "bin/web_scraper -u monzo.com" }

    it "returns url to scrape" do
      expect(%x(#{successful_command})).to eq("I'm going to scrape monzo.com!\n")
    end

    it "returns 0 as exit code" do
      %x(#{successful_command})

      expect($?.exitstatus).to eq(0)
    end
  end
end