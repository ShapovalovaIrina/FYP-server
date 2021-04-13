defmodule FypWeb.FavouriteController do
  @moduledoc """
  Controller for functions which are relative to favourite pet data
  """

  use FypWeb, :controller
  import FypWeb.ControllerUtils
  alias Fyp.Favourites

  require Logger

  def add_favourite_pet(conn, %{"pet_id" => pet_id} = _params) do
    %{"user_id" => user_id} = conn.assigns.authentication.claims
    case Favourites.add_favourite_for_user(user_id, pet_id) do
      {:ok, _user} ->
        conn |> put_status(200) |> json(successful_status())

      {:error, :not_found} ->
        conn |> put_status(404) |> json(not_found_status())

      {:error, reason} ->
        Logger.error("Error in favourite controller was caused by: #{inspect(reason)}")
        conn |> put_status(400) |> json(bad_status())
    end
  end

  def remove_favourite_pet(conn, %{"pet_id" => pet_id} = _params) do
    %{"user_id" => user_id} = conn.assigns.authentication.claims
    case Favourites.delete_favourite_from_user(user_id, pet_id) do
      {:ok, _user} ->
        conn |> put_status(200) |> json(successful_status())

      {:error, :not_found} ->
        conn |> put_status(404) |> json(not_found_status())

      {:error, :no_related_pets} ->
        conn |> put_status(404) |> json(no_related_entities())

      {:error, reason} ->
        Logger.error("Error in favourite controller was caused by: #{inspect(reason)}")
        conn |> put_status(400) |> json(bad_status())
    end
  end
end
