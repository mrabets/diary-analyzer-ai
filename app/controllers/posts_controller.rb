# frozen_string_literal: true

class PostsController < ApplicationController
  include Pagy::Backend
  include ResourceResponseHandling

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show edit update destroy analyze]
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
    respond_with_resource(@post, notice: I18n.t("posts.create.success"))
  end

  def update
    @post.assign_attributes(post_params)
    respond_with_resource(@post, notice: I18n.t("posts.update.success"))
  end

  def destroy
    destroy_resource(@post, notice: I18n.t("posts.destroy.success"))
  end

  def analyze
    DiaryAnalyzer.call(post: @post, user: current_user)

    redirect_to resource_path(@post), notice: I18n.t("posts.analyze.success")
  rescue AnalysisError, PremiumNotFoundError => e
    redirect_to resource_path(@post), alert: e.message
  end

  private

  def set_posts_with_pagy
    @pagy, @posts = pagy(PagyPostsFetcher.call(search_query: params[:search_query]), items: 5)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content).tap { |params| params[:user_id] = current_user.id }
  end
end
