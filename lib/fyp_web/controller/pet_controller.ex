defmodule FypWeb.PetController do
  @moduledoc """
  Controller for functions which are relative to pet data
  """

  use FypWeb, :controller
  import FypWeb.ControllerUtils
  alias Fyp.Pets
  alias Fyp.Photos

  @doc "Get pet list from server"
  def pet_list(conn, _params) do
    pet_list = Pets.pet_list()
    conn |> put_status(200) |> json(pet_list)
  end

  @doc "Get pet record (single) by pet id"
  def pet(conn, %{"id" => id} = _params) do
    case Pets.pet_by_id(id) do
      {:ok, pet} -> conn |> put_status(200) |> json(pet)
      {:error, :not_found} -> conn |> put_status(404) |> json(not_found_status())
    end
  end
end
