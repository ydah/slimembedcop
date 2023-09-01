# frozen_string_literal: true

module Slimembedcop
  # Collect RuboCop offenses from Template code.
  class OffenseCollector
    class << self
      def run(path, config, source)
        snippets(path, source).flat_map do |snippet|
          RubyOffenseCollector.run(path, config, snippet[:code]).map do |offense|
            Offense.new(path, snippet[:offset], offense, source)
          end
        end
      end

      private

      def snippets(path, source)
        Extractor.run(path, source)
      end
    end
  end
end
