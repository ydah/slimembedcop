# frozen_string_literal: true

require "rubocop"

module Slimembedcop
  # Collect RuboCop offenses from Ruby code.
  class RubyOffenseCollector
    class << self
      def run(path, config, source, autocorrect)
        return [] unless rubocop_processed_source(path, config, source).valid_syntax?

        rubocop_team(config, autocorrect).investigate(rubocop_processed_source(path, config, source)).offenses.reject(&:disabled?)
      end

      private

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

      def rubocop_processed_source(path, config, source)
        ::RuboCop::ProcessedSource.new(source, config.target_ruby_version, path).tap do |processed_source|
          processed_source.config = config if processed_source.respond_to?(:config)
          processed_source.registry = registry if processed_source.respond_to?(:registry)
        end
      end

      def rubocop_team(config, autocorrect)
        ::RuboCop::Cop::Team.new(
          registry,
          config,
          autocorrect: autocorrect,
          display_cop_names: true,
          extra_details: true,
          stdin: "")
      end
    end
  end
end
