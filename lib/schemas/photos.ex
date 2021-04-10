defmodule Schemas.Photos do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for photo table.
  Fields:
    - id (id)
    - photo_url (string)
    - pet_id (uuid)

  Belongs to Pets (Many to One relationship with pets).
  """

  @primary_key {:photo_url, :string, autogenerate: false}
  schema "photos" do
    belongs_to :pets, Schemas.Pets, foreign_key: :pets_id, type: :binary_id
  end

  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:photo_url, :pets_id])
  end
end
