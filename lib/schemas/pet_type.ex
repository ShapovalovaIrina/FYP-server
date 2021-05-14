defmodule PetType do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for pet type table.
  Fields:
    - id (id)
    - type (string)

  Has many pets (One to Many relationship with pets).
  """

  @derive {Jason.Encoder, only: [:type]}
  @primary_key {:id, :id, autogenerate: false}
  schema "pet_type" do
    field :type, :string
    has_many :pets, Schemas.Pets
  end

  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:id, :type])
  end
end
