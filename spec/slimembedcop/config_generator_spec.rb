# frozen_string_literal: true

RSpec.describe Slimembedcop::ConfigGenerator do
  describe "#run" do
    subject { described_class.new(option).run }

    let(:option) { Slimembedcop::Option.new("") }

    context "when valid condition" do
      specify do
        is_expected.to be_a(RuboCop::Config)
      end
    end

    context "when non-existent forced_configuration_path" do
      let(:option) { Slimembedcop::Option.new("--config=non_existent.yml") }

      specify do
        expect { subject }.to raise_error(RuboCop::ConfigNotFoundError)
      end
    end
  end
end
