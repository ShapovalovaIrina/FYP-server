defmodule FypWeb.FavouriteController do
  @moduledoc """
  Controller for functions which are relative to favourite pet data
  """

  use FypWeb, :controller
  use OpenApiSpex.ControllerSpecs
  import FypWeb.ControllerUtils
  alias Fyp.Favourites
  alias OpenApi.ResponsesSchema.{SuccessfulStatus, BadStatus, NotFoundStatus, Unauthenticated, AccessForbidden}
  alias OpenApi.PetSchemas.{Pets, PetsIds}

  require Logger

  tags ["Favourites"]
  security [%{"authorization" => []}]

  operation :add_favourite_pet,
    summary: "Add pet with pet ID to favourite of authorized user",
    parameters: [
      pet_id: [
        in: :path,
        description: "Pet ID",
        type: :string,
        required: true,
        example: "123e4567-e89b-12d3-a456-426655440000"
      ]
    ],
    responses: %{
      200 => {"Success", "application/json", SuccessfulStatus},
      400 => {"Bad status", "application/json", BadStatus},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden},
      404 => {"Not found", "application/json", NotFoundStatus}
    }

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

  operation :get_favourite_pet,
    summary: "Get favourite pets of authorized user",
    responses: %{
      200 => {"Favourite pet list", "application/json", Pets},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden},
      404 => {"Not found", "application/json", NotFoundStatus}
    }

  def get_favourite_pet(conn, _params) do
    %{"user_id" => user_id} = conn.assigns.authentication.claims
    case Favourites.get_assoc_pets(user_id) do
      {:error, :not_found} -> conn |> put_status(404) |> json(not_found_status())
      {:ok, pets} -> conn |> put_status(200) |> json(pets)
    end
  end

  operation :remove_favourite_pet,
    summary: "Remove pet with pet ID from favourite of authorized user",
    parameters: [
      pet_id: [
        in: :path,
        description: "Pet ID",
        type: :string,
        required: true,
        example: "123e4567-e89b-12d3-a456-426655440000"
      ]
    ],
    responses: %{
      200 => {"Success", "application/json", SuccessfulStatus},
      400 => {"Bad status", "application/json", BadStatus},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden},
      404 => {"Not found", "application/json", NotFoundStatus}
    }

  def remove_favourite_pet(conn, %{"pet_id" => pet_id} = _params) do
    %{"user_id" => user_id} = conn.assigns.authentication.claims
    case Favourites.delete_favourite_from_user(user_id, pet_id) do
      {:ok, _user} ->
        conn |> put_status(200) |> json(successful_status())

      {:error, :not_found} ->
        conn |> put_status(404) |> json(not_found_status())

      {:error, :no_related_pets} ->
        conn |> put_status(404) |> json(not_found_status())

      {:error, reason} ->
        Logger.error("Error in favourite controller was caused by: #{inspect(reason)}")
        conn |> put_status(400) |> json(bad_status())
    end
  end
end
