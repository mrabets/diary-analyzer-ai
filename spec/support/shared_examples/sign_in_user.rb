# frozen_string_literal: true

shared_context "with signed in user" do
  include_context "user"

  before do
    # Temporarily disable confirmable to avoid sending confirmation email
    # user.confirm
    sign_in(user)
  end
end
