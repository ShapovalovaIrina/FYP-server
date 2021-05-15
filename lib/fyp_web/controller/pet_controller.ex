defmodule FypWeb.PetController do
  @moduledoc """
  Controller for functions which are relative to pet data
  """

  use FypWeb, :controller
  use OpenApiSpex.ControllerSpecs
  import FypWeb.ControllerUtils
  alias OpenApi.ResponsesSchema.{SuccessfulStatus, BadStatus, NotFoundStatus, Unauthenticated, AccessForbidden}
  alias OpenApi.PetSchemas.{Pet, PetParameters, Pets}

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

  operation :add_pet,
    summary: "Create pet with provided parameters. Only for users with admin access rights",
    request_body: {"Pet parameters", "application/json", PetParameters},
    responses: %{
      201 => {"Success", "application/json", SuccessfulStatus},
      400 => {"Bad status", "application/json", BadStatus},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden}
    },
    security: [%{"authorization" => []}]


  def add_pet(conn, params) do
    res = case validate_input_pet_params(params) do
      true -> Fyp.Pets.create(params)
      false -> :incorrect_body
    end

    case res do
      :error -> conn |> put_status(400) |> json(bad_status())
      :incorrect_body -> conn |> put_status(400) |> json(bad_status())
      {_, _uuid} -> conn |> put_status(201) |> json(successful_status())
    end
  end

  defp validate_input_pet_params(params) do
    Map.has_key?(params, "name") and
    Map.has_key?(params, "shelter_id") and
    Map.has_key?(params, "description") and
    is_list(Map.get(params, "photos"))
  end

  operation :remove_pet,
    summary: "Remove pet by ID. Only for users with admin access rights",
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
      200 => {"Success", "application/json", SuccessfulStatus},
      400 => {"Bad status", "application/json", BadStatus},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden},
      404 => {"Not found", "application/json", NotFoundStatus}
    },
    security: [%{"authorization" => []}]

  def remove_pet(conn, %{"id" => id} = _params) do
    case Fyp.Pets.delete_pet(id) do
      :not_found -> conn |> put_status(404) |> json(not_found_status())
      :error -> conn |> put_status(400) |> json(bad_status())
      :ok -> conn |> put_status(200) |> json(successful_status())
    end
  end
end
