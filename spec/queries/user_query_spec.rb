# frozen_string_literal: true

require "rails_helper"

describe UserQuery do
  include_context "user"

  describe ".all_except" do
    subject { described_class.all_except(user) }

    let!(:users) { create_list(:user, 3) }

    it { is_expected.to eq(users) }
  end
end
