# frozen_string_literal: true

require "slimi"

module Slimembedcop
  # Extract Ruby codes from Slim embedded code.
  class Extractor
    class << self
      def run(path, source)
        @path = path
        @source = source

        ranges.map do |(begin_, end_)|
          { code: source[begin_...end_], offset: begin_ }
        end
      end

      private

      def ranges
        result = []
        index = 0
        begin_pos = 0
        leading_spaces = 0
        inside_ruby = false
        @source.each_line do |line|
          if block_start?(line)
            leading_spaces = line.match(/^\s*/)[0].length
            inside_ruby = true
            begin_pos = index += line.length
            next
          end

          if inside_ruby && block_end?(line, leading_spaces)
            result << [begin_pos, index - 1]
            inside_ruby = false
          end

          index += line.length
        end

        if inside_ruby
          result << [begin_pos, index - 1]
        end

        result
      end

      def block_start?(line)
        line.strip.start_with?("ruby:")
      end

      def block_end?(line, leading_spaces)
        line.match(/^\s{#{leading_spaces}}\S/) ||
          (leading_spaces.zero? && line.match(/^\S/))
      end
    end
  end
end
