# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation_users, only: %i[index]
  before_action :set_profile_user, only: %i[show]

  def index
  end

  def show
  end

  private

  def set_profile_user
    @user = params[:id].present? ? User.find(params[:id]) : current_user
  end

  def set_conversation_users
    @users = User.all_except(current_user)
  end
end
