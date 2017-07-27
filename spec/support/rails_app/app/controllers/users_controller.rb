class UsersController < ApplicationController
  protect_from_forgery with: :exception

  ## @h: Get All Users
  ## @r: get /users
  def index
  end

  ## @h: Show One User
  ## @r: get /users/:id
  def show
  end

  # @h: create user
  # @r: post /users
  def created
  end
end
