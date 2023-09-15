# frozen_string_literal: true

module Slimembedcop
  # Collect RuboCop offenses from Template code.
  class OffenseCollector
    def initialize(path, config, source, autocorrect, debug)
      @path = path
      @config = config
      @source = source
      @autocorrect = autocorrect
      @debug = debug
    end

    def run
      snippets.flat_map do |snippet|
        RubyOffenseCollector.new(@path, @config, snippet[:code], @autocorrect, @debug).run.map do |offense|
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
