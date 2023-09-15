# frozen_string_literal: true

RSpec.describe Slimembedcop::RubyOffenseCollector do
  describe '#run' do
    subject { described_class.new('dummy.slim', config, source, false).run }

    let(:option) { Slimembedcop::Option.new('') }
    let(:config) { Slimembedcop::ConfigGenerator.new(option).run }
    let(:source) do
      <<~RUBY
        "a"
      RUBY
    end

    context 'when valid condition' do
      it 'returns expected offenses' do
        expect(subject).not_to be_empty
      end
    end

    context 'when rubocop:todo comment' do
      let(:source) do
        <<~RUBY
          "a" # rubocop:todo Style/StringLiterals
        RUBY
      end

      it 'excludes disabled offenses' do
        expect(subject).to be_empty
      end
    end

    context 'when rubocop:disable comment' do
      let(:source) do
        <<~RUBY
          "a" # rubocop:disable Style/StringLiterals
        RUBY
      end

      it 'excludes disabled offenses' do
        expect(subject).to be_empty
      end
    end

    context 'when rubocop:disable comment with missing cop enable directive' do
      let(:source) do
        <<~RUBY
          # rubocop:disable Style/StringLiterals
          "a"
        RUBY
      end

      it 'excludes disabled offenses' do
        expect(subject.size).to eq 1
        expect(subject.first.cop_name).to eq 'Lint/MissingCopEnableDirective'
      end
    end
  end
end
