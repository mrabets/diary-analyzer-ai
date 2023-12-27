# frozen_string_literal: true

require "rails_helper"

describe WelcomeController do
  describe "GET #index" do
    before { get :index }

    it "renders index template" do
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:success)
    end
  end
end
