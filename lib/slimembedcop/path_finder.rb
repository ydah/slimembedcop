# frozen_string_literal: true

require "pathname"
require "set"

module Slimembedcop
  # Collect file paths from given path patterns.
  class PathFinder
    def initialize(options, config)
      @default_patterns = options.default_path_patterns
      @exclude_patterns = config.for_all_cops["Exclude"] || []
      @path_patterns = options.args
    end

    def run
      matching_paths(patterns) { |path| !excluded?(path) }.sort
    end

    private

    def matching_paths(patterns, &block)
      patterns.each_with_object(Set.new) do |pattern, set|
        ::Pathname.glob(pattern) do |pathname|
          next unless pathname.file?

          path = pathname.expand_path.to_s
          set.add(path) if block.nil? || yield(path)
        end
      end
    end

    def excluded?(path)
      excluded.include?(path)
    end

    def excluded
      @excluded ||= matching_paths(@exclude_patterns)
    end

    def patterns
      return @default_patterns if @path_patterns.empty?

      @path_patterns.map do |pattern|
        next pattern unless File.directory?(pattern)

        @default_patterns.map do |default|
          File.join(pattern, default)
        end.flatten
      end
    end
  end
end
