# frozen_string_literal: true

class PostsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :set_posts_with_pagy, only: %i[index]

  def index
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: I18n.t("posts.create.success") }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: I18n.t("posts.update.success") }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: I18n.t("posts.destroy.success") }
      format.json { head :no_content }
    end
  end

  private

  def set_posts_with_pagy
    @pagy, @posts = pagy(posts_to_show, items: 5)
  end

  def posts_to_show
    posts = params[:search_query].present? ? Post.search(params[:search_query]) : Post.all
    posts.order(created_at: :desc)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content).tap { |params| params[:user_id] = current_user.id }
  end
end
