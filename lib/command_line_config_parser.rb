# frozen_string_literal: true

require 'optparse'
require 'uri'

class CommandLineConfigParser
  class Error < StandardError
    def initialize(parser, custom_message = nil)
      message = if custom_message
                  "#{custom_message}\n\n#{parser}"
                else
                  parser.to_s
                end
      super(message)
    end
  end
  InvalidURLError = Class.new(Error)
  MissingURLError = Class.new(Error)

  def initialize(arguments)
    @arguments = arguments
  end

  def parse
    options = {}
    option_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: web_parser [options]'

      opts.on('-u', '--url URL', 'Initial url from which to begin') do |url|
        options[:url] = url
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end
    option_parser.parse!(arguments)
    raise MissingURLError.new(option_parser, 'Missing --url argument') unless options[:url]
    raise InvalidURLError.new(option_parser, 'Invalid argument for --url') unless options[:url] =~ /\A#{URI.regexp(%w[http https])}\z/
    options
  end

  private

  attr_reader :arguments
end
