# frozen_string_literal: true

RSpec.describe Slimembedcop::Extractor do
  describe "#run" do
    subject { described_class.new(source).run }

    let(:source) do
      <<~'SLIM'
        ruby:
          message = "world"
        html
          head
            title Slim Samples
          body
            ruby:
              if some_var = true
                do_something
              end
            h1 Hello, #{message}
        ruby:
          do_something /pattern/i
      SLIM
    end

    context "when valid source" do
      it "returns extracted Ruby codes and offset" do
        expect(subject).to eq(
          [
            { code: "  message = \"world\"", offset: 6 },
            { code: "      if some_var = true\n        do_something\n      end", offset: 78 },
            { code: "  do_something /pattern/i", offset: 165 }
          ]
        )
      end
    end
  end
end
