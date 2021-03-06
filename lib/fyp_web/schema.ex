defmodule FypWeb.Schema do
  use Absinthe.Schema
  import_types FypWeb.Schema.ContentTypes

  alias FypWeb.Resolvers.Content

  query do
    @desc "Get all pets"
    field :pets, list_of(:pet) do
      resolve &Content.list_pets/3
    end

    @desc "Get pet by id"
    field :pet_by_id, :pet do
      arg :id, non_null(:id)
      resolve &Content.pet_by_id/3
    end
  end
end
