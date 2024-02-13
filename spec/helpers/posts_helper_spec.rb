# frozen_string_literal: true

require "rails_helper"

describe PostsHelper do
  let(:post) { build(:post, data: { analyze_result: }) }
  let(:analyze_result) do
    {
      emotions: %w[happy sad],
      keywords: %w[work job],
      recommendations: %w[smile]
    }
  end

  describe "#emotions" do
    it "returns emotions" do
      expect(helper.emotions(post)).to eq("happy, sad")
    end
  end

  describe "#keywords" do
    it "returns keywords" do
      expect(helper.keywords(post)).to eq("work, job")
    end
  end

  describe "#recommendations" do
    it "returns recommendations" do
      expect(helper.recommendations(post)).to eq("smile")
    end
  end
end
