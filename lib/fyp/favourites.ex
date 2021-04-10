defmodule Fyp.Favourites do
  @moduledoc """
  """

  alias Fyp.Repo
  alias Schemas.{Users, Pets}

  require Logger

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
      nil -> {:error, :not_found}
      pet ->
        {data, changeset} = pet_preloaded_changeset(pet)
        pet_with_user = Ecto.Changeset.put_assoc(changeset, :users, [user | data.users])
        Repo.update(pet_with_user)
    end
  end

  defp delete_pet_assoc(%Users{} = user, pet_id) do
    case Repo.get(Pets, pet_id) do
      nil -> {:error, :not_found}
      pet ->
        {data, changeset} = pet_preloaded_changeset(pet)
        remove_user(data.users, changeset, user)
    end
  end

  defp pet_preloaded_changeset(pet) do
    preloaded_data = Repo.preload(pet, :users)
    {preloaded_data, Ecto.Changeset.change(preloaded_data)}
  end

  defp remove_user([], _changeset, _user) do
    {:error, :no_related_user}
  end

  defp remove_user(users, changeset, user) do
    pet_with_user = Ecto.Changeset.put_assoc(changeset, :users, Enum.filter(users, fn u -> u.id != user.id end))
    Repo.update(pet_with_user)
  end

  def get_assoc_pets(user_id) do
    case Repo.get(Users, user_id) do
      nil -> {:error, :not_found}
      user -> {:ok, Repo.preload(user, :pets).pets}
    end
  end

  def get_assoc_users(pet_id) do
    case Repo.get(Pets, pet_id) do
      nil -> {:error, :not_found}
      pet -> {:ok, Repo.preload(pet, :users).users}
    end
  end
end
