# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsController do
  include_examples "with signed in user"

  describe "GET #index" do
    subject(:get_index) { get :index }

    let!(:post) { create(:post, user:) }

    it "returns a success response" do
      get_index
      expect(response).to be_successful
    end

    it "returns all posts" do
      get_index
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe "GET #show" do
    subject(:get_show) { get :show, params: { id: post.id } }

    let(:post) { create(:post, user:) }

    it "returns a success response" do
      get_show
      expect(response).to be_successful
    end

    it "returns the post" do
      get_show
      expect(assigns(:post)).to eq(post)
    end
  end

  describe "GET #new" do
    subject(:get_new) { get :new }

    it "returns a success response" do
      get_new
      expect(response).to be_successful
    end

    it "returns a new post" do
      get_new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "GET #edit" do
    subject(:get_edit) { get :edit, params: { id: post.id } }

    let(:post) { create(:post, user:) }

    it "returns a success response" do
      get_edit
      expect(response).to be_successful
    end

    it "returns the post" do
      get_edit
      expect(assigns(:post)).to eq(post)
    end
  end

  describe "POST #create" do
    subject(:post_create) { post :create, params: { post: post_params } }

    let(:post_params) { attributes_for(:post) }

    it "creates a new Post" do
      expect { post_create }.to change(Post, :count).by(1)
    end

    it "redirects to the created post" do
      post_create
      expect(response).to redirect_to(Post.last)
    end

    context "with invalid params" do
      let(:post_params) { { title: "" } }

      it "doesn't create a new Post" do
        expect { post_create }.not_to change(Post, :count)
      end
    end
  end

  describe "PUT #update" do
    subject(:put_update) { put :update, params: { id: post.id, post: post_params } }

    let(:post) { create(:post, user:) }
    let(:new_content) { Faker::Lorem.paragraph }
    let(:post_params) { { title: "Updated Title", content: new_content } }

    it "updates the requested post" do
      put_update
      post.reload
      expect(post.title).to eq("Updated Title")
      expect(post.content.to_plain_text).to eq(new_content)
    end

    it "redirects to the post" do
      put_update
      expect(response).to redirect_to(post)
    end

    context "with invalid params" do
      let(:post_params) { { title: "" } }

      it "doesn't update the requested post" do
        expect { put_update }.not_to change(post, :title)
      end
    end
  end

  describe "DELETE #destroy" do
    subject(:delete_destroy) { delete :destroy, params: { id: post.id } }

    let!(:post) { create(:post, user:) }

    it "destroys the requested post" do
      expect { delete_destroy }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      delete_destroy
      expect(response).to redirect_to(posts_url)
    end
  end
end
