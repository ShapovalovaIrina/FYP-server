defmodule Fyp.Pets do
  @moduledoc """
  Operations with pets data (including photos) from database.
  """

  alias Schemas.Pets
  require Logger

  def create(pet_with_photos, on_conflict \\ :replace_all) do
    opts = [
      on_conflict: on_conflict,
      conflict_target: :id
    ]

    {photos, pet_params} = Map.split(pet_with_photos, [:photos])

    changeset = Pets.changeset(%Pets{}, pet_params)
    case Fyp.Repo.insert(changeset, opts) do
      {:ok, %Pets{id: uuid}} ->
        Logger.info("Insert pet with uuid: #{uuid}")
        Fyp.Photos.create_all(photos, uuid)
      {:error, reason} ->
        Logger.warn("Insertion failed. Reason: #{inspect(reason)}")
        :error
    end
  end
end
