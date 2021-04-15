defmodule FypWeb.PetController do
  @moduledoc """
  Controller for functions which are relative to pet data
  """

  use FypWeb, :controller
  use OpenApiSpex.ControllerSpecs
  import FypWeb.ControllerUtils
  alias OpenApi.ResponsesSchema.NotFoundStatus
  alias OpenApi.PetSchemas.{Pet, Pets}

  tags ["Pets"]
  security [%{}]

  operation :pet_list,
    summary: "Get all pets",
    responses: %{
      200 => {"Pet list", "application/json", Pets}
    }

  def pet_list(conn, _params) do
    pet_list = Fyp.Pets.pet_list()
    conn |> put_status(200) |> json(pet_list)
  end

  operation :pet,
    summary: "Get pet by ID",
    parameters: [
      id: [
        in: :path,
        description: "Pet ID",
        type: :string,
        required: true,
        example: "123e4567-e89b-12d3-a456-426655440000"
      ]
    ],
    responses: %{
      200 => {"Pet", "application/json", Pet},
      404 => {"Not found", "application/json", NotFoundStatus}
    }

  def pet(conn, %{"id" => id} = _params) do
    case Fyp.Pets.pet_by_id(id) do
      {:ok, pet} -> conn |> put_status(200) |> json(pet)
      {:error, :not_found} -> conn |> put_status(404) |> json(not_found_status())
    end
  end
end
