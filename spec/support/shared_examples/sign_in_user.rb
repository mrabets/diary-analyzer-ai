# frozen_string_literal: true

shared_context "when signed in user" do
  let(:user) { create(:user) }

  before do
    user.confirm
    sign_in(user)
  end
end
