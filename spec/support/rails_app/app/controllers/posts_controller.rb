class PostsController < ApplicationController
  protect_from_forgery with: :exception

  ## @h: Get All Posts
  ## @r: get /posts
  def index
  end

  ## @h: Show One Post
  ## @r: get /posts/:id
  ## **NOTE** this is still under development
  ## @res-serializer: post
  def show
  end

  ## @h: create post
  ## @r: post /posts
  ## @b-serializer: post
  ## @res-serializer: Post
  def created
  end
end
