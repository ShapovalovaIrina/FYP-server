defmodule Fyp.Shelter do
  @moduledoc """
  """

  import Ecto.Query

  alias Schemas.Shelter
  alias Fyp.Repo

  require Logger

  def create(shelter_params) do
    opts = [
      returning: [:id],
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: {:unsafe_fragment, "(title)"}
    ]

    changeset = Shelter.changeset(%Shelter{}, shelter_params)

    case Repo.insert(changeset, opts) do
      {:ok, %Shelter{id: id, title: title} = shelter} ->
        Logger.info("Insert shelter with id #{id} and title #{title}")
        {:ok, shelter}

      {:error, reason} ->
        Logger.warn("User insertion failed. Reason: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def get_all_shelters() do
    query = from(Shelter)
    Repo.all(query)
  end

  def shelter_struct_to_shelter_map(%Shelter{} = shelter) do
    Map.take(shelter, [
      :id,
      :title,
      :vk_link,
      :site_link
    ])
  end

  def struct_shelter_to_map_shelter(_incorrect_input) do
    %{}
  end
end
