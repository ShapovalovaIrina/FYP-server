defmodule Schemas.Pets do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for pet table.
  Fields:
    - id (uuid)
    - name (string)
    - breed (string)
    - gender (string)
    - birth (string)
    - height (string)
    - description (string)
    - shelter_id (id)

  Has many photos (One to Many relationship with photos).
  Belongs to shelter (Many to one relationship with shelters).
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "pets" do
    field :name, :string
    field :breed, :string
    field :gender, :string
    field :birth, :string
    field :height, :string
    field :description, :string
    has_many :photos, Schemas.Photos
    belongs_to :shelter, Schemas.Shelter, foreign_key: :shelter_id, type: :id
    many_to_many :users, Schemas.Users,
                 join_through: "favourite_pets",
                 join_keys: [pet_id: :id, user_id: :id],
                 on_replace: :delete
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:id, :name, :breed, :gender, :birth, :height, :description, :shelter_id])
  end
end
