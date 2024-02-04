# frozen_string_literal: true

require "rails_helper"

describe DiaryAnalyzer do
  include_context "user"

  describe ".call" do
    subject(:call) { described_class.call(post:, user:) }

    let(:post) { create(:post, content: "I'm happy. But I lost my job ") }
    let(:open_ai_api_client) { instance_double(OpenAi::ApiClient) }
    let(:text) do
      "\n1. Emotions: happy\n2. Keywords: happy, job\n3. Recommendations: - Smile. Find a new job.\nGo to specialist"
    end
    let(:analysis_result) do
      {
        "choices" => [
          {
            "text" => text
          }
        ]
      }
    end

    before do
      allow(OpenAi::ApiClient).to receive(:new).and_return(open_ai_api_client)
      allow(open_ai_api_client).to receive(:analyze_diary).and_return(analysis_result)
    end

    context "when user has premium subscription" do
      before { create(:subscription, status: "active", user:) }

      it "analyzes the diary" do
        call

        expect(post.reload.data).to eq(
          analyze_result: {
            emotions: ["happy"],
            keywords: %w[happy job],
            recommendations: ["Smile. Find a new job.", "Go to specialist"]
          }
        )
      end

      context "when analysis result has an error" do
        let(:analysis_result) { { error: "Error" } }

        it "raises AnalysisError" do
          expect { call }.to raise_error(AnalysisError, "Error")
        end
      end
    end

    context "when user has no premium subscription" do
      it "raises PremiumNotFoundError" do
        expect { call }.to raise_error(PremiumNotFoundError)
      end
    end
  end
end
