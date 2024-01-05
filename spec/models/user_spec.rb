# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  data                   :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           not null
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "rails_helper"

describe User do
  let(:user) { build(:user) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }
  end

  describe "associations" do
    it { is_expected.to have_many(:posts).class_name("Post").dependent(:destroy) }
    it { is_expected.to have_many(:conversations).dependent(:destroy).class_name("Conversation") }
    it { is_expected.to have_many(:messages).dependent(:destroy).class_name("Message") }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe "callbacks" do
    describe "before_save" do
      let(:avatar_url) { "avatar_url" }

      before { allow(Faker::Avatar).to receive(:image).and_return(avatar_url) }

      it "adds a avatar url" do
        user.save

        expect(Faker::Avatar).to have_received(:image)
        expect(user.data[:avatar_url]).to eq(avatar_url)
      end
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: SecureRandom.uuid,
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.name
        }
      )
    end

    context "when user does not exist" do
      it "creates a new user" do
        expect { described_class.from_omniauth(auth) }.to change(described_class, :count).by(1)

        user = described_class.from_omniauth(auth)
        expect(user.uid).to eq(auth[:uid])
        expect(user.provider).to eq(auth[:provider])
        expect(user.email).to eq(auth.dig(:info, :email))
        expect(user.name).to eq(auth.dig(:info, :name))
      end
    end

    context "when user already exists" do
      before { create(:user, provider: auth[:provider], uid: auth[:uid]) }

      it "finds the existing user" do
        expect { described_class.from_omniauth(auth) }.not_to change(described_class, :count)

        user = described_class.from_omniauth(auth)
        expect(user.uid).to eq(auth[:uid])
        expect(user.provider).to eq(auth[:provider])
      end
    end
  end
end
