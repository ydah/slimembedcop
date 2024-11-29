# frozen_string_literal: true

require 'rubocop'

module Slimembedcop
  # Collect RuboCop offenses from Ruby code.
  class RubyOffenseCollector
    def initialize(path, config, source, autocorrect, debug)
      @path = path
      @config = config
      @source = source
      @autocorrect = autocorrect
      @debug = debug
    end

    def run
      return [] unless processed_source.valid_syntax?

      team.investigate(processed_source).offenses.reject(&:disabled?)
    end

    private

    def processed_source
      ::RuboCop::ProcessedSource.new(@source, @config.target_ruby_version, @path).tap do |processed_source|
        processed_source.config = @config if processed_source.respond_to?(:config)
        processed_source.registry = registry if processed_source.respond_to?(:registry)
      end
    end

    def team
      ::RuboCop::Cop::Team.mobilize(
        registry,
        @config,
        autocorrect: @autocorrect,
        debug: @debug,
        display_cop_names: true,
        extra_details: true,
        stdin: ''
      )
    end

    def registry
      @registry ||= begin
        all_cops = if ::RuboCop::Cop::Registry.respond_to?(:all)
                     ::RuboCop::Cop::Registry.all
                   else
                     ::RuboCop::Cop::Cop.all
                   end

        ::RuboCop::Cop::Registry.new(all_cops)
      end
    end
  end
end
