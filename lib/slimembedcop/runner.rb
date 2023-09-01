# frozen_string_literal: true

require "parallel"
require "stringio"

module Slimembedcop
  # Run investigation and auto-correction.
  class Runner
    class << self
      def run(paths, formatter, config)
        on_started(formatter, paths)
        result = run_in_parallel(paths, formatter, config)
        on_finished(paths, formatter, result)
        result.flat_map do |(_, offenses)|
          offenses
        end
      end

      private

      def on_started(formatter, paths)
        formatter.started(paths)
      end

      def run_in_parallel(paths, formatter, config)
        ::Parallel.map(paths) do |path|
          offenses_per_file = []
          on_file_started(formatter, path)
          source = ::File.read(path)
          offenses = investigate(path, config, source)
          offenses_per_file |= offenses
          break if offenses.none?(&:correctable?)

          on_file_finished(path, formatter, offenses_per_file)
          [path, offenses_per_file]
        end
      end

      def investigate(path, config, source)
        OffenseCollector.run(path, config, source)
      end

      def on_file_started(formatter, path)
        formatter.file_started(path, {})
      end

      def on_file_finished(path, formatter, offenses)
        formatter.file_finished(path, offenses)
      end

      def on_finished(paths, formatter, result)
        original = formatter.output
        formatter.instance_variable_set(:@output, ::StringIO.new)
        result.each do |(path, offenses)|
          on_file_started(formatter, path)
          on_file_finished(path, formatter, offenses)
        end
        formatter.instance_variable_set(:@output, original)

        formatter.finished(paths)
      end
    end
  end
end
