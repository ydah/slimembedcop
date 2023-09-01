# frozen_string_literal: true

require "forwardable"

require "parser"
require "rubocop"

module Slimembedcop
  # Wraps a RuboCop offense.
  class Offense
    extend ::Forwardable

    attr_reader :path, :offset

    delegate(
      %i[column column_length cop_name correctable? corrected_with_todo?
         corrected? corrector eql? hash highlighted_area line
         message real_column severity] => :offense_with_real_location
    )

    def initialize(path, offset, offense, source)
      @path = path
      @offset = offset
      @offense = offense
      @source = source
    end

    def location
      @location ||= ::Parser::Source::Range.new(
        buffer,
        @offense.location.begin_pos + @offset,
        @offense.location.end_pos + @offset
      )
    end

    def marshal_dump
      {
        begin_pos: @offense.location.begin_pos,
        cop_name: @offense.cop_name,
        end_pos: @offense.location.end_pos,
        path: @path,
        message: @offense.message.dup.force_encoding(::Encoding::UTF_8).scrub,
        offset: @offset,
        severity: @offense.severity.to_s,
        source: @source,
        status: @offense.status
      }
    end

    def marshal_load(hash)
      @path = hash[:path]
      @offset = hash[:offset]
      @offense = ::RuboCop::Cop::Offense.new(
        hash[:severity],
        ::Parser::Source::Range.new(
          ::Parser::Source::Buffer.new(
            @path,
            source: @source
          ),
          hash[:begin_pos],
          hash[:end_pos]
        ),
        hash[:message],
        hash[:cop_name],
        hash[:status].to_sym
      )
      @source = hash[:source]
    end

    private

    def buffer
      ::Parser::Source::Buffer.new(path, source: @source)
    end

    def offense_with_real_location
      ::RuboCop::Cop::Offense.new(
        @offense.severity.name,
        location,
        @offense.message,
        @offense.cop_name,
        @offense.status,
        @offense.corrector
      )
    end
  end
end
