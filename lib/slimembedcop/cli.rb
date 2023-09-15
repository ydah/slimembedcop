# frozen_string_literal: true

require 'rubocop'

module Slimembedcop
  # Command line interface for Slimembedcop.
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      options = Option.new(@argv)
      formatter = ::RuboCop::Formatter::ProgressFormatter.new($stdout, color: options.color)
      config = ConfigGenerator.new(options).run
      paths = PathFinder.new(options, config).run
      offenses = Runner.new(paths, formatter, options, config).run
      exit(offenses.empty? ? 0 : 1)
    end
  end
end
