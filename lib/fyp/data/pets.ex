defmodule Fyp.Pets do
  @moduledoc """
  Operations with pets data (including photos) from database.
  """

  import Ecto.Query
  alias Schemas.{Pets, Type}
  alias Fyp.{Repo, Photos}
  require Logger

  def create(pet_with_photos) do
    opts = [
      returning: [:id],
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: {:unsafe_fragment, "(name, shelter_id, type_id)"}
    ]

    {photos, pet_params} =
      case Map.has_key?(pet_with_photos, "photos") do
        true ->
          Map.split(pet_with_photos, ["photos"])

        false ->
          {photo, pets} = Map.split(pet_with_photos, [:photos])
          photo = Map.new(photo, fn {k, v} -> {Atom.to_string(k), v} end)
          {photo, pets}
      end

    changeset = Pets.changeset(%Pets{}, pet_params)

    case Repo.insert(changeset, opts) do
      {:ok, %Pets{id: uuid}} ->
        Logger.info("Insert pet with uuid: #{uuid}.")
        res = Photos.create_all(photos, uuid)
        {res, uuid}

      {:error, reason} ->
        Logger.warn("Pet insertion failed. Reason: #{inspect(reason)}")
        :error
    end
  end

  def pet_list_pagination(type_filter \\ [], shelter_filter \\ [], limit_value \\ 10, cursor \\ nil, direction \\ :after) do
    query =
      Pets
      |> add_type_filter(type_filter)
      |> add_shelter_filter(shelter_filter)
      |> preload([:photos, :shelter, :type])

    %{entries: entries, metadata: metadata} =
      case {cursor, direction} do
        {nil, _} -> Repo.paginate(query, cursor_fields: [:name, :shelter_id, :type_id], limit: limit_value)
        {cursor_value, :after} -> Repo.paginate(query, after: cursor_value, cursor_fields: [:name, :shelter_id, :type_id], limit: limit_value)
        {cursor_value, :before} -> Repo.paginate(query, before: cursor_value, cursor_fields: [:name, :shelter_id, :type_id], limit: limit_value)
      end

    entries =
      Enum.map(entries, fn pet ->
        Map.update(pet, :photos, [], fn photos -> Photos.struct_list_to_map_list(photos) end)
      end)
    %{entries: entries, metadata: metadata}
  end

  def pet_list(type_filter \\ [], shelter_filter \\ []) do
    query =
      Pets
      |> add_type_filter(type_filter)
      |> add_shelter_filter(shelter_filter)
      |> preload([:photos, :shelter, :type])

    Repo.all(query)
    |> Enum.map(fn pet ->
      Map.update(pet, :photos, [], fn photos -> Photos.struct_list_to_map_list(photos) end)
    end)
  end

  defp add_type_filter(query, []) do
    query
  end

  defp add_type_filter(query, type_filter) when is_list(type_filter) do
    from q in query, where: q.type_id in ^type_filter
  end

  defp add_type_filter(query, _incorrect_filter) do
    query
  end

  defp add_shelter_filter(query, []) do
    query
  end

  defp add_shelter_filter(query, shelter_filter) when is_list(shelter_filter) do
    from q in query, where: q.shelter_id in ^shelter_filter
  end

  defp add_shelter_filter(query, _incorrect_filter) do
    query
  end

  def pet_by_id(id) do
    case Repo.get(Pets, id) |> Repo.preload([:photos, :shelter, :type]) do
      nil ->
        {:error, :not_found}

      struct ->
        struct =
          Map.update(struct, :photos, [], fn photos ->
            Photos.struct_list_to_map_list(photos)
          end)

        {:ok, struct}
    end
  end

  defp pet_by_id_without_preload(id) do
    case Repo.get(Pets, id) do
      nil -> {:error, :not_found}
      struct -> {:ok, struct}
    end
  end

  def delete_pet(id) do
    with {:ok, pet} <- pet_by_id_without_preload(id),
         {:ok, _} <- Repo.delete(pet) do
      :ok
    else
      {:error, :not_found} ->
        :not_found

      {:error, changeset} ->
        Logger.error("Error in pet deletion. Pet id: #{id}. Changeset: #{inspect(changeset)}")
        :error
    end
  end

  def map_from_pet_struct(struct) do
    with map <-
           Map.take(struct, [
             :id,
             :name,
             :breed,
             :gender,
             :birth,
             :height,
             :description,
             :photos,
             :shelter,
             :type
           ]),
         {_, map_with_shelter} <-
           Map.get_and_update(map, :shelter, fn current_value ->
             {current_value, Fyp.Shelter.shelter_struct_to_shelter_map(current_value)}
           end),
         {_, ready_map} <-
           Map.get_and_update(map_with_shelter, :type, fn current_value ->
             {current_value, struct_type_to_map_type(current_value)}
           end) do
      ready_map
    else
      error ->
        Logger.warn("Error in getting map from pet struct. Error: #{inspect(error)}")
        %{}
    end
  end

  defp struct_type_to_map_type(%Type{} = type_struct) do
    Map.take(type_struct, [
      :type
    ])
  end

  defp struct_type_to_map_type(_incorrect_input) do
    %{}
  end
end
