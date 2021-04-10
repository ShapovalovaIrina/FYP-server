defmodule Fyp.Users do
  @moduledoc """
  """

  import Ecto.Query
  alias Schemas.Users
  alias Fyp.Repo

  require Logger

  def create(%{name: _, email: _} = user_params) do
    opts = [
      on_conflict: :nothing,
      conflict_target: :id
    ]

    changeset = Users.changeset(%Users{}, user_params)

    case Repo.insert(changeset, opts) do
      {:ok, %Users{id: id, email: email}} ->
        Logger.info("Insert user with id #{id} and email #{email}")
        {:ok, id}

      {:error, reason} ->
        Logger.warn("User insertion failed. Reason: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def show(user_id) do
    case Repo.get(Users, user_id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def delete(user_id) do
    case Repo.delete_all(from u in Users, where: u.id == ^user_id) do
      {n, _} when n > 0 ->
        Logger.info("Successfully delete user with id #{user_id}. Number of deleted entities: #{n}.")
        :ok

      {0, _} ->
        Logger.warn("No such user. User id: #{user_id}. Number of deleted entities: 0.")
        :not_found

      {nil, _} ->
        Logger.error("User insertion failed.")
        :error
    end
  end

  def map_from_struct(%Users{} = user) do
    Map.take(user, [
      :name,
      :email
    ])
  end

  def map_from_struct(_not_user) do
    {:error, :not_user_struct}
  end
end
