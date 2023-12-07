# frozen_string_literal: true

require "rails_helper"

describe ApplicationMailer do
  describe "from" do
    it "uses the default from address" do
      expect(described_class.default[:from]).to eq("mrabets@proton.me")
    end
  end
end
