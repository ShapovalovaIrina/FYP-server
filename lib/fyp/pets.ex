defmodule Fyp.Pets do
  @moduledoc """
  Operations with pets data (including photos) from database.
  """

  import Ecto.Query
  alias Schemas.Pets
  alias Fyp.{Repo, Photos}
  require Logger

  def create(pet_with_photos, on_conflict \\ :replace_all) do
    opts = [
      on_conflict: on_conflict,
      conflict_target: :id
    ]

    {photos, pet_params} = Map.split(pet_with_photos, ["photos"])

    changeset = Pets.changeset(%Pets{}, pet_params)
    case Repo.insert(changeset, opts) do
      {:ok, %Pets{id: uuid}} ->
        Logger.info("Insert pet with uuid: #{uuid}")
        res = Fyp.Photos.create_all(photos, uuid)
        {res, uuid}
      {:error, reason} ->
        Logger.warn("Insertion failed. Reason: #{inspect(reason)}")
        :error
    end
  end

  def pet_list() do
    query =
      from pet in Pets,
           join: a in assoc(pet, :photos),
           preload: [photos: a]
    Repo.all(query)
    |> Enum.map(fn struct -> map_from_pet_struct(struct) end)
  end

  def pet_by_id(id) do
    case Repo.get(Pets, id) |> Repo.preload(:photos) do
      nil -> {:error, :not_found}
      struct -> {:ok, map_from_pet_struct(struct)}
    end
  end

  defp map_from_pet_struct(struct) do
    {_, map} =
      Map.take(struct, [
        :id,
        :name,
        :breed,
        :gender,
        :birth,
        :height,
        :description,
        :photos
      ])
      |> Map.get_and_update(:photos, fn current_value -> {current_value, Photos.struct_list_to_map_list(current_value)} end)
    map
  end
end
