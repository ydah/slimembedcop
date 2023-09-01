# frozen_string_literal: true

require_relative "slimembedcop/version"

module Slimembedcop
  autoload :Cli, "slimembedcop/cli"
  autoload :ConfigGenerator, "slimembedcop/config_generator"
  autoload :Extractor, "slimembedcop/extractor"
  autoload :Offense, "slimembedcop/offense"
  autoload :OffenseCollector, "slimembedcop/offense_collector"
  autoload :PathFinder, "slimembedcop/path_finder"
  autoload :RubyOffenseCollector, "slimembedcop/ruby_offense_collector"
  autoload :Runner, "slimembedcop/runner"
end
