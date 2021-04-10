defmodule FypWeb.UserController do
  @moduledoc """
  Controller for functions which are relative to user data
  """
  use FypWeb, :controller
  import FypWeb.ControllerUtils
  alias Fyp.Users

  def create_user(conn, %{"name" => name, "email" => email} = _params) do
    case Users.create(%{name: name, email: email}) do
      {:ok, _id} -> conn |> put_status(201) |> json(successful_status())
      {:error, _reason} -> conn |> put_status(400) |> json(bad_status())
    end
  end

  def show_user(conn, %{"id" => id} = _params) do
    case Users.show(id) do
      {:ok, user} -> conn |> put_status(200) |> json(user)
      {:error, :not_found} -> conn |> put_status(404) |> json(not_found_status())
    end
  end

  def delete_user(conn, %{"id" => id} = _params) do
    case Users.delete(id) do
      :ok -> conn |> put_status(200) |> json(successful_status())
      :not_found -> conn |> put_status(404) |> json(not_found_status())
      :error -> conn |> put_status(400) |> json(bad_status())
    end
  end
end
