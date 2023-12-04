# frozen_string_literal: true

shared_context "with signed in user" do
  let(:user) { create(:user) }

  before do
    user.confirm
    sign_in(user)
  end
end
