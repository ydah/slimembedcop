module Slimembedcop
  # Command line options.
  class Option
    attr_reader :version, :autocorrect, :forced_config_path, :color, :args

    def initialize(argv)
      opt = OptionParser.new
      @version = false
      @autocorrect = false
      @forced_config_path = nil
      @color = nil

      opt.banner = "Usage: slimembedcop [options] [file1, file2, ...]"
      opt.on('-v', '--version', 'Display version.') { @version = true }
      opt.on("-a", "--autocorrect", "Autocorrect offenses.") { @autocorrect = true }
      opt.on("-c", "--config=", "Specify configuration file.") { |path| @forced_config_path = path }
      opt.on("--[no-]color", "Force color output on or off.") { |value| @color = value }
      @args = opt.parse(argv)
    end
  end
end
