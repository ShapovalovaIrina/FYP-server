defmodule Fyp.Users do
  @moduledoc """
  """

  alias Schemas.Users
  alias Fyp.Repo

  require Logger

  def create(%{id: _, name: _, email: _} = user_params, replace_opt \\ :replace_all) do
    opts = [
      on_conflict: replace_opt,
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
    with {:ok, user} <- show(user_id),
         {:ok, _} <- Repo.delete(user) do
      :ok
    else
      {:error, :not_found} ->
        :not_found

      {:error, changeset} ->
        Logger.error(
          "Error in user deletion. User id: #{user_id}. Changeset: #{inspect(changeset)}"
        )
        :error
    end
  end

  def ensure_exist(%{id: _, name: _, email: _} = user_params) do
    create(user_params, :nothing)
  end

  def map_from_struct(%Users{} = user) do
    Map.take(user, [
      :id,
      :name,
      :email
    ])
  end

  def map_from_struct(_not_user) do
    {:error, :not_user_struct}
  end
end
