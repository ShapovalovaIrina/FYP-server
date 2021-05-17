defmodule FypWeb.PetController do
  @moduledoc """
  Controller for functions which are relative to pet data
  """

  use FypWeb, :controller
  use OpenApiSpex.ControllerSpecs
  import FypWeb.ControllerUtils

  alias OpenApi.ResponsesSchema.{
    SuccessfulStatus,
    BadStatus,
    NotFoundStatus,
    Unauthenticated,
    AccessForbidden
  }
  alias OpenApi.PetSchemas.{Pet, PetParameters, Pets, PetsPagination}
  
  tags ["Pets"]
  security [%{}]

  operation :pet_list,
    summary: "Get all pets",
    parameters: [
      type_id: [
        in: :query,
        description: "Type ID for filtering query. Available type ID can be found from /type endpoint",
        type: :string,
        example: "1,2",
        required: false
      ],
      shelter_id: [
        in: :query,
        description: "Shelter ID for filtering query. Available type ID can be found from /shelter endpoint",
        type: :string,
        example: "2,4",
        required: false
      ]
    ],
    responses: %{
      200 => {"Pet list", "application/json", Pets}
    }

  def pet_list(conn, params) do
    shelter_filter = split_shelter_parameter(params["shelter_id"])
    type_filter = split_type_parameter(params["type_id"])

    pet_list = Fyp.Pets.pet_list(type_filter, shelter_filter)
    conn |> put_status(200) |> json(pet_list)
  end

  defp split_shelter_parameter(shelter_id) do
    if shelter_id, do: String.split(shelter_id, ",", trim: true), else: []
  end

  defp split_type_parameter(type_id) do
    if type_id, do: String.split(type_id, ",", trim: true), else: []
  end

  operation :pet_chunks,
    summary: "Get pet data by chunks (cursor-based pagination)",
    parameters: [
      type_id: [
        in: :query,
        description: "Type ID for filtering query. Available type ID can be found from /type endpoint",
        type: :string,
        example: "1,2",
        required: false
      ],
      shelter_id: [
        in: :query,
        description: "Shelter ID for filtering query. Available type ID can be found from /shelter endpoint",
        type: :string,
        example: "2,4",
        required: false
      ],
      limit: [
        in: :query,
        description: "Entries limit for query. Default value is 10",
        type: :integer,
        example: "10",
        required: false
      ],
      cursor: [
        in: :query,
        description: "Cursor for requesting next/previous entries. Available after first request without cursor. If no cursor provided, first {limit} entries are fetched",
        type: :string,
        example: "g3QAAAABZAACaWRhAQ==",
        required: false
      ],
      direction: [
        in: :query,
        description: "Query direction. Available types: after, before. Default direction is after",
        type: :string,
        example: "after",
        required: false
      ]
    ],
    responses: %{
      200 => {"Pet list", "application/json", PetsPagination}
    }

  def pet_chunks(conn, params) do
    shelter_filter = split_shelter_parameter(params["shelter_id"])
    type_filter = split_type_parameter(params["type_id"])
    limit = parse_limit_parameter(params["limit"])
    cursor = parse_cursor_parameter(params["cursor"])
    direction = parse_direction_parameter(params["direction"])

    pet_list_with_metadata = Fyp.Pets.pet_list_pagination(type_filter, shelter_filter, limit, cursor, direction)
    conn |> put_status(200) |> json(pet_list_with_metadata)
  end

  defp parse_limit_parameter(limit) when not is_nil(limit) do
    case Integer.parse(limit) do
      {int, _binary} -> int
      :error -> 10
    end
  end

  defp parse_limit_parameter(_limit)  do
    10
  end

  defp parse_cursor_parameter(cursor) do
    if is_bitstring(cursor), do: cursor, else: nil
  end

  defp parse_direction_parameter(direction) do
    if direction in ["before", "after"], do: String.to_atom(direction), else: :after
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
    params =
      if is_list(params["photos"]) do
        params
      else
        Map.replace(params, "photos", [])
      end

    case Fyp.Pets.create(params) do
      :error -> conn |> put_status(400) |> json(bad_status())
      {_, _uuid} -> conn |> put_status(201) |> json(successful_status())
    end
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
