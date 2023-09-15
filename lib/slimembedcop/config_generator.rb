# frozen_string_literal: true

require 'rubocop'

module Slimembedcop
  # Generates a configuration for RuboCop.
  class ConfigGenerator
    def initialize(option)
      @default_config_path = option.default_config_path
      @forced_config_path = option.forced_config_path
    end

    def run
      ::RuboCop::ConfigLoader.merge_with_default(merged_config, loaded_path)
    end

    private

    def loaded_path
      @forced_config_path || implicit_config_path || @default_config_path
    end

    def merged_config
      ::RuboCop::Config.create(merged_config_hash, loaded_path)
    end

    def merged_config_hash
      result = default_config
      result = ::RuboCop::ConfigLoader.merge(result, user_config) if user_config
      result
    end

    def user_config
      if instance_variable_defined?(:@user_config)
        @user_config
      else
        @user_config =
          if @forced_config_path
            ::RuboCop::ConfigLoader.load_file(@forced_config_path)
          elsif (path = implicit_config_path)
            ::RuboCop::ConfigLoader.load_file(path)
          end
      end
    end

    def default_config
      ::RuboCop::ConfigLoader.load_file(@default_config_path)
    end

    def implicit_config_path
      if instance_variable_defined?(:@implicit_config_path)
        @implicit_config_path
      else
        @implicit_config_path = %w[.slimembedcop.yml .rubocop.yml].find do |path|
          ::File.exist?(path)
        end
      end
    end
  end
end
