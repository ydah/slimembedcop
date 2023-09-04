# frozen_string_literal: true

require 'parser'
require 'rubocop/cop/legacy/corrector'

module Slimembedcop
  # Apply auto-corrections to Template file.
  class TemplateCorrector
    def initialize(path, offenses, source)
      @path = path
      @offenses = offenses
      @source = source
    end

    def run
      ::RuboCop::Cop::Legacy::Corrector.new(source_buffer, corrections).rewrite
    end

    private

    def corrections
      @offenses.select(&:corrector).map do |offense|
        lambda do |corrector|
          corrector.import!(offense.corrector, offset: offense.offset)
        end
      end
    end

    def source_buffer
      ::Parser::Source::Buffer.new(@path, source: @source)
    end
  end
end
