# frozen_string_literal: true

class UsersController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_conversation_users_with_pagy, only: %i[index]
  before_action :set_profile_user, only: %i[show]

  def index
  end

  def show
  end

  private

  def set_profile_user
    @user = params[:id].present? ? User.find(params[:id]) : current_user
  end

  def set_conversation_users_with_pagy
    @pagy, @users = pagy(UserQuery.all_except(current_user), items: 5)
  end
end
