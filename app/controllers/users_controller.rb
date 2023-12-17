# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all_except(current_user)
  end

  def show
    @user = User.find(params[:id])
  end

  def profile
  end
end
