class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :likes

  ## @b:
  ##  {
  ##    title: "awesome gem",
  ##    body: "lorep sump text over here"
  ##  }

  ## @res:
  ## {
  ##   title: "awesome gem",
  ##   body: "lorep sump text over here",
  ##   likes: 0,
  ##   updated_at: "91231-543-157",
  ##   created_at: "123-1231-123"
  ## }
end
end
