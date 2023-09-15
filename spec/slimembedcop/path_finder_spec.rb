# frozen_string_literal: true

RSpec.describe Slimembedcop::PathFinder do
  describe '#run' do
    subject { described_class.new(options, config).run }

    let(:options) { Slimembedcop::Option.new(paths) }
    let(:config) { Slimembedcop::ConfigGenerator.new(options).run }
    let(:paths) { [] }

    context 'when normal file path' do
      let(:paths) { %w[spec/fixtures/dummy.slim] }

      it 'returns expected file paths' do
        is_expected.to eq(
          [File.expand_path('spec/fixtures/dummy.slim')]
        )
      end
    end

    context 'when glob pattern' do
      let(:paths) { %w[spec/**/*.slim] }

      it 'returns expected file paths' do
        is_expected.to eq(
          [File.expand_path('spec/fixtures/dummy.slim')]
        )
      end
    end

    context 'when directory path' do
      let(:paths) { %w[spec] }

      it 'scans the directory for files matching the default patterns' do
        is_expected.to eq(
          [File.expand_path('spec/fixtures/dummy.slim')]
        )
      end
    end

    context 'when empty patterns' do
      let(:paths) { [] }

      it 'uses default patterns' do
        is_expected.to eq(
          [File.expand_path('spec/fixtures/dummy.slim')]
        )
      end
    end
  end
end
