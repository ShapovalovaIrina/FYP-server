defmodule FypWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  alias FypWeb.Resolvers.Content

  object :pet do
    field :id, :string
    field :name, :string
    field :breed, :string
    field :gender, :string
    field :birth, :string
    field :height, :string
    field :description, :string
    field :photos, list_of(:string) do
      arg :amount, :integer
      resolve &Content.photo_amount/3
    end
  end
end
