defmodule FypWeb.UserController do
  @moduledoc """
  Controller for functions which are relative to user data
  """
  use FypWeb, :controller
  use OpenApiSpex.ControllerSpecs
  import FypWeb.ControllerUtils
  alias Fyp.Users
  alias OpenApi.ResponsesSchema.{SuccessfulStatus, BadStatus, NotFoundStatus, Unauthenticated, AccessForbidden}
  alias OpenApi.UsersSchema.User

  tags ["Users"]
  security [%{"authorization" => []}]

  operation :create_user,
    summary: "Create user with params from auth token",
    responses: %{
      201 => {"Success", "application/json", SuccessfulStatus},
      400 => {"Bad status", "application/json", BadStatus},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden}
    }

  def create_user(conn, _params) do
    %{"user_id" => id, "email" => email} = conn.assigns.authentication.claims
    case Users.create(%{id: id, email: email}) do
      {:ok, _id} -> conn |> put_status(201) |> json(successful_status())
      {:error, _reason} -> conn |> put_status(400) |> json(bad_status())
    end
  end

  operation :show_user,
    summary: "Get user info. ID is getting from auth token",
    responses: %{
      200 => {"User response", "application/json", User},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden},
      404 => {"Not found", "application/json", NotFoundStatus}
    }

  def show_user(conn, _params) do
    %{"user_id" => id} = conn.assigns.authentication.claims
    case Users.show(id) do
      {:ok, user} -> conn |> put_status(200) |> json(user)
      {:error, :not_found} -> conn |> put_status(404) |> json(not_found_status())
    end
  end

  operation :delete_user,
    summary: "Delete user. ID is getting from auth token",
    responses: %{
      200 => {"Success", "application/json", SuccessfulStatus},
      400 => {"Bad status", "application/json", BadStatus},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden},
      404 => {"Not found", "application/json", NotFoundStatus}
    }

  def delete_user(conn, _params) do
    %{"user_id" => id} = conn.assigns.authentication.claims
    case Users.delete(id) do
      :ok -> conn |> put_status(200) |> json(successful_status())
      :not_found -> conn |> put_status(404) |> json(not_found_status())
      :error -> conn |> put_status(400) |> json(bad_status())
    end
  end
end
