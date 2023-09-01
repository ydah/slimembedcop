# frozen_string_literal: true

require "pathname"
require "set"

module Slimembedcop
  # Collect file paths from given path patterns.
  class PathFinder
    class << self
      def run(default_patterns, exclude_patterns, path_patterns)
        @default_patterns = default_patterns
        @exclude_patterns = exclude_patterns || []
        @path_patterns = path_patterns
        matching_paths(patterns) do |path|
          !excluded?(path)
        end.sort
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
end
