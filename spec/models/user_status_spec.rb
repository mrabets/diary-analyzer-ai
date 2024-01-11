# frozen_string_literal: true

require "rails_helper"

describe UserStatus do
  describe "validations" do
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:uid) }
  end
end
