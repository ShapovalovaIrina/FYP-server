defmodule Fyp.Photos do
  @moduledoc """
  Operations with pets photos data from database.
  """

  alias Schemas.Photos
  require Logger

  def create_all(%{"photos" => photos}, pet_id) do
    photos
    |> Enum.map(fn url -> %{photo_url: url, pets_id: pet_id} end)
    |> Enum.each(fn params -> create(params) end)
  end

  def create(%{photo_url: _, pets_id: pet_id} = photo_params, on_conflict \\ :replace_all) do
    opts = [
      on_conflict: on_conflict,
      conflict_target: :id
    ]

    changeset = Photos.changeset(%Photos{}, photo_params)
    case Fyp.Repo.insert(changeset, opts) do
      {:ok, _struct} ->
        :ok
      {:error, reason} ->
        Logger.warn("Photo insertion failed for pet #{pet_id}}. Reason: #{inspect(reason)}")
        :error
    end
  end

  def struct_list_to_map_list(list) do
    Enum.map(list, fn struct -> struct.photo_url end)
  end
end
