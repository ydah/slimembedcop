# frozen_string_literal: true

module Slimembedcop
  # Command line options.
  class Option
    attr_reader :version, :autocorrect, :forced_config_path, :color, :debug,
                :args, :default_config_path, :default_path_patterns

    def initialize(argv)
      opt = OptionParser.new
      @version = false
      @autocorrect = false
      @forced_config_path = nil
      @color = nil
      @debug = false
      @default_config_path = File.expand_path('../default.yml', __dir__)
      @default_path_patterns = %w[**/*.slim].freeze

      opt.banner = 'Usage: slimembedcop [options] [file1, file2, ...]'
      opt.on('-v', '--version', 'Display version.') { @version = true }
      opt.on('-a', '--autocorrect', 'Autocorrect offenses.') { @autocorrect = true }
      opt.on('-c', '--config=', 'Specify configuration file.') { |path| @forced_config_path = path }
      opt.on('--[no-]color', 'Force color output on or off.') { |value| @color = value }
      opt.on('-d', '--debug', 'Display debug info.') { |value| @debug = value }
      @args = opt.parse(argv)
    end
  end
end
