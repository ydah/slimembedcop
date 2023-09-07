# frozen_string_literal: true

require "optparse"
require "rubocop"

module Slimembedcop
  # Command line interface for Slimembedcop.
  class Cli
    def initialize(argv)
      @argv = argv
      @default_config_path = File.expand_path("../default.yml", __dir__)
      @default_path_patterns = %w[**/*.slim].freeze
    end

    def run
      options = Option.new(@argv)
      formatter = ::RuboCop::Formatter::ProgressFormatter.new($stdout, color: options.color)
      config = ConfigGenerator.run(@default_config_path, options.forced_config_path)
      paths = PathFinder.run(@default_path_patterns, config.for_all_cops["Exclude"], @argv)
      offenses = Runner.run(paths, formatter, config, options.autocorrect)
      exit(offenses.empty? ? 0 : 1)
    end
  end
end
