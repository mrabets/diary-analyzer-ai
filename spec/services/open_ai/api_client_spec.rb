# frozen_string_literal: true

require "rails_helper"

describe OpenAi::ApiClient do
  subject(:api_client) { described_class.new(diary_text:) }

  let(:diary_text) { "Today was a tough day." }

  before { allow(Retriable).to receive(:retriable).and_call_original }

  describe "#analyze_diary" do
    it "sends a post request to analyze diary text", :vcr do
      VCR.use_cassette("open_ai_api_client/analyze_diary") do
        response = api_client.analyze_diary
        text = response.or_default["choices"].first["text"]

        expect(text).to include("Emotions")
        expect(text).to include("Keywords")
        expect(text).to include("Recommendations")
      end
    end
  end

  context "when cache is not used" do
    let(:null_cache) { Faulty::Cache::Null.new }
    let(:faulty_circuit) { Faulty::Circuit.new("test_circuit", cache: null_cache) }

    before { allow(Faulty).to receive(:circuit).and_return(faulty_circuit) }

    it "retries the request and succeeds" do
      VCR.use_cassette("open_ai_api_client/analyze_diary") do
        api_client.analyze_diary

        expect(Retriable).to have_received(:retriable).at_least(:once)
      end
    end

    context "when the circuit is open" do
      before { allow(Retriable).to receive(:retriable).and_raise(Faraday::Error) }

      it "returns the default error message" do
        response = api_client.analyze_diary
        expect(response).to be_error
      end
    end
  end
end
