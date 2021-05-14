defmodule Fyp.Favourites do
  @moduledoc """
  """

  alias Fyp.Repo
  alias Schemas.{Users, Pets}

  def add_favourite_for_user(user_id, pet_id) do
    case Repo.get(Users, user_id) do
      nil -> {:error, :not_found}
      user -> add_pet_assoc(user, pet_id)
    end
  end

  def delete_favourite_from_user(user_id, pet_id) do
    case Repo.get(Users, user_id) do
      nil -> {:error, :not_found}
      user -> delete_pet_assoc(user, pet_id)
    end
  end

  defp add_pet_assoc(%Users{} = user, pet_id) do
    case Repo.get(Pets, pet_id) do
      nil ->
        {:error, :not_found}

      pet ->
        {data, changeset} = user_preloaded_changeset(user)
        user_with_pets = Ecto.Changeset.put_assoc(changeset, :pets, [pet | data.pets])
        Repo.update(user_with_pets)
    end
  end

  defp delete_pet_assoc(%Users{} = user, pet_id) do
    case Repo.get(Pets, pet_id) do
      nil ->
        {:error, :not_found}

      pet ->
        {data, changeset} = user_preloaded_changeset(user)
        remove_pet(data.pets, changeset, pet)
    end
  end

  defp user_preloaded_changeset(user) do
    preloaded_data = Repo.preload(user, :pets)
    {preloaded_data, Ecto.Changeset.change(preloaded_data)}
  end

  defp remove_pet([], _changeset, _pet) do
    {:error, :no_related_pets}
  end

  defp remove_pet(pets, changeset, pet) do
    user_with_pets =
      Ecto.Changeset.put_assoc(changeset, :pets, Enum.filter(pets, fn p -> p.id != pet.id end))

    Repo.update(user_with_pets)
  end

  def get_assoc_pets(user_id) do
    case Repo.get(Users, user_id) do
      nil ->
        {:error, :not_found}

      user ->
        pets =
          Repo.preload(user, :pets).pets
          |> Repo.preload([:photos, :shelter, :pet_type])
          |> Enum.map(fn pet ->
            Map.update(pet, :photos, [], fn photos ->
              Fyp.Photos.struct_list_to_map_list(photos)
            end)
          end)

        {:ok, pets}
    end
  end

  def get_assoc_users(pet_id) do
    case Repo.get(Pets, pet_id) do
      nil -> {:error, :not_found}
      pet -> {:ok, Repo.preload(pet, :users).users}
    end
  end
end
