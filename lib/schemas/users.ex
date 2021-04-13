defmodule Schemas.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for users table.
  Fields:
    - id (id)
    - name (string)
    - email (string)

  Many to many relationship with pets through table "favourite_pets".
  """

  @primary_key {:id, :string, autogenerate: false}
  schema "users" do
    field :name, :string
    field :email, :string
    many_to_many :pets, Schemas.Pets,
                 join_through: "favourite_pets",
                 join_keys: [user_id: :id, pet_id: :id],
                 on_replace: :delete
  end

  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:id, :name, :email])
  end
end
