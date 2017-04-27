require 'ostruct'
require 'optparse'

module IDB
  class Options
    def self.parse(argv)
      options = OpenStruct.new
      parser = new(options)

      begin
        parser.parse!(argv)
      rescue OptionParser::MissingArgument, OptionParser::InvalidOption => e
        if block_given?
          yield(e, parser)
        else
          raise
        end
      end
      options.parser = parser
      options
      end

      def initialize(options)
        apply_defaults(options)

        @opt_parser = OptionParser.new do |o|
          o.banner = "Usage: idb-public-api [options]"

          o.on('-c', '--config=FILE', 'alternate config file') do |value|
            options.config_file = value
          end

        end
      end

      def parse!(argv)
        @opt_parser.parse!(argv)
      end

      def banner
        @opt_parser.banner
      end

      def summarize
        @opt_parser.summarize
      end

      private
        def apply_defaults(options)
          options.config_file = "/etc/idb-public-api/config.yml"
        end
  end
end
