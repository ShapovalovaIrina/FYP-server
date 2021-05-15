defmodule FypWeb.ShelterController do
  @moduledoc """
  Controller for functions which are relative to shelter data
  """

  use FypWeb, :controller
  use OpenApiSpex.ControllerSpecs
  import FypWeb.ControllerUtils
  alias OpenApi.ResponsesSchema.{SuccessfulStatus, BadStatus, Unauthenticated, AccessForbidden}
  alias OpenApi.ShelterSchema.{Shelter, Shelters}

  tags ["Shelters"]
  security [%{}]

  operation :create,
    summary: "Create shelter with provided parameters. Only for users with admin access rights",
    request_body: {"Shelter parameters", "application/json", Shelter},
    responses: %{
      201 => {"Success", "application/json", SuccessfulStatus},
      400 => {"Bad status", "application/json", BadStatus},
      401 => {"Unauthenticated", "application/json", Unauthenticated},
      403 => {"Access forbidden", "application/json", AccessForbidden}
    }

  def create(conn, params) do
    case Fyp.Shelter.create(params) do
      {:ok, _shelter} -> conn |> put_status(201) |> json(successful_status())
      {:error, _reason} -> conn |> put_status(400) |> json(bad_status())
    end
  end

  operation :shelter_list,
    summary: "Get all shelters",
    responses: %{
      200 => {"Shelter list", "application/json", Shelters}
    }

  def shelter_list(conn, _params) do
    shelter_list = Fyp.Shelter.get_all_shelters()
    conn |> put_status(200) |> json(shelter_list)
  end
end
