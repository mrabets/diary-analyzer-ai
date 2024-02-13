# frozen_string_literal: true

require "rails_helper"

describe UsersController do
  include_examples "with signed in user"

  describe "GET #show" do
    before { get :show, params: { id: user.id } }

    it "assings user" do
      expect(assigns(:user)).to eq(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    let(:users) { create_list(:user, 3) }

    before do
      allow(UserQuery).to receive(:all_except).and_return(User.where(id: users.map(&:id)))

      get :index
    end

    it "assings users" do
      expect(assigns(:users)).to eq(users)
      expect(response).to have_http_status(:success)
    end
  end
end
