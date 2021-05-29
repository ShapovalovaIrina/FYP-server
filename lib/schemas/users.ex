defmodule Schemas.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for users table.
  Fields:
    - id (id)
    - email (string)

  Many to many relationship with pets through table "favourite_pets".
  """

  @derive {Jason.Encoder, only: [:id, :email]}
  @primary_key {:id, :string, autogenerate: false}
  schema "users" do
    field :email, :string
    many_to_many :pets, Schemas.Pets,
                 join_through: "favourite_pets",
                 join_keys: [user_id: :id, pet_id: :id],
                 on_replace: :delete
  end

  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:id, :email])
  end
end
