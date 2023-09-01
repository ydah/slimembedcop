# frozen_string_literal: true

require "optparse"
require "rubocop"

module Slimembedcop
  # Command line interface for Slimembedcop.
  class Cli
    class << self
      DEFAULT_CONFIG_PATH = File.expand_path("../default.yml", __dir__)
      DEFAULT_PATH_PATTERNS = %w[**/*.slim].freeze

      def run(argv)
        options = parse_options!(argv)
        formatter = ::RuboCop::Formatter::ProgressFormatter.new($stdout, color: options[:color])
        config = ConfigGenerator.run(DEFAULT_CONFIG_PATH, options[:forced_config_path])
        paths = PathFinder.run(DEFAULT_PATH_PATTERNS, config.for_all_cops["Exclude"], argv)
        offenses = Runner.run(paths, formatter, config)
        exit(offenses.empty? ? 0 : 1)
      end

      private

      def parse_options!(argv)
        options = {}
        parser = ::OptionParser.new
        parser.banner = "Usage: slimembedcop [options] [file1, file2, ...]"
        parser.version = VERSION
        parser.on("-c", "--config=", "Specify configuration file. (default: #{DEFAULT_CONFIG_PATH} or .rubocop.yml)") do |file_path|
          options[:forced_config_path] = file_path
        end
        parser.on("--[no-]color", "Force color output on or off.") do |value|
          options[:color] = value
        end
        parser.parse!(argv)
        options
      end
    end
  end
end
