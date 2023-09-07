# frozen_string_literal: true

module Slimembedcop
  # Collect RuboCop offenses from Template code.
  class OffenseCollector
    def initialize(path, config, source, autocorrect)
      @path = path
      @config = config
      @source = source
      @autocorrect = autocorrect
    end

    def run
      snippets.flat_map do |snippet|
        RubyOffenseCollector.new(@path, @config, snippet[:code], @autocorrect).run.map do |offense|
          Offense.new(@path, snippet[:offset], offense, @source)
        end
      end
    end

    private

    def snippets
      Extractor.new(@source).run
    end
  end
end
