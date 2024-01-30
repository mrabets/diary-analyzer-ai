# frozen_string_literal: true

require "rails_helper"

describe OmniauthUser do
  subject(:find_or_create) { described_class.find_or_create(auth_hash) }

  let(:user_uid) { SecureRandom.uuid }
  let(:auth_hash) do
    OmniAuth::AuthHash.new({
                             provider: "provider_name",
                             uid: user_uid,
                             info: { email: "john@example.com", name: "John Doe" }
                           })
  end

  describe ".find_or_create" do
    context "when omniauth user exists" do
      let!(:user) { create(:user, provider: auth_hash.provider, uid: user_uid) }

      it "returns the existing user" do
        expect(find_or_create).to eq(Success(user))
      end
    end

    context "when a registered user exists with the same email" do
      let!(:user) { create(:user, email: auth_hash.info.email) }

      it "returns the existing registered user" do
        expect(find_or_create).to eq(Success(user))
      end
    end

    context "when no user exists with the same email or provider/uid" do
      it "creates a new user" do
        expect { described_class.find_or_create(auth_hash) }
          .to change(User, :count).by(1)
      end

      it "returns a new user with the correct attributes" do
        user = find_or_create.value!
        expect(user.provider).to eq(auth_hash.provider)
        expect(user.uid).to eq(auth_hash.uid)
        expect(user.email).to eq(auth_hash.info.email)
        expect(user.name).to eq(auth_hash.info.name)
      end
    end

    context "when user creation fails" do
      let(:auth_hash) do
        OmniAuth::AuthHash.new({
                                 provider: "provider_name",
                                 uid: user_uid,
                                 info: { email: "", name: "John Doe" }
                               })
      end

      it "returns a failure" do
        expect(find_or_create).to be_failure
      end
    end
  end
end
