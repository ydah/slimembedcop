# frozen_string_literal: true

require "parallel"
require "stringio"

module Slimembedcop
  # Run investigation and auto-correction.
  class Runner
    def initialize(paths, formatter, options, config)
      @paths = paths
      @formatter = formatter
      @autocorrect = options.autocorrect
      @config = config
    end

    def run
      on_started
      result = run_in_parallel
      on_finished(result)
      result.flat_map { |(_, offenses)| offenses }
    end

    private

    def on_started
      @formatter.started(@paths)
    end

    def run_in_parallel
      ::Parallel.map(@paths) do |path|
        offenses_per_file = []
        max_trials_count.times do
          on_file_started(path)
          source = ::File.read(path)
          offenses = investigate(path, source)
          offenses_per_file |= offenses
          break if offenses.none?(&:correctable?)

          next unless @autocorrect

          correct(path, offenses, source)
        end

        on_file_finished(path, offenses_per_file)
        [path, offenses_per_file]
      end
    end

    def max_trials_count
      if @autocorrect
        7
      else
        1
      end
    end

    def investigate(path, source)
      OffenseCollector.new(path, @config, source, @autocorrect).run
    end

    def correct(path, offenses, source)
      rewritten_source = TemplateCorrector.new(path, offenses, source).run
      ::File.write(path, rewritten_source)
    end

    def on_file_started(path)
      @formatter.file_started(path, {})
    end

    def on_file_finished(path, offenses)
      @formatter.file_finished(path, offenses)
    end

    def on_finished(result)
      original = @formatter.output
      @formatter.instance_variable_set(:@output, ::StringIO.new)
      result.each do |(path, offenses)|
        on_file_started(path)
        on_file_finished(path, offenses)
      end
      @formatter.instance_variable_set(:@output, original)

      @formatter.finished(@paths)
    end
  end
end
