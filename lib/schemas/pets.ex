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

  Has many photos (One to Many relationship with photos).
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
    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:id, :name, :breed, :gender, :birth, :height, :description])
  end
end
