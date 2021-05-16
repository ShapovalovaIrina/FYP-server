defmodule FypWeb.TypeController do
  @moduledoc """
  Controller for functions which are relative to shelter data
  """

  use FypWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias OpenApi.TypeSchema.Types

  tags ["Types"]
  security [%{}]

  operation :type_list,
    summary: "Get all pet types",
    responses: %{
      200 => {"Type list", "application/json", Types}
    }

  def type_list(conn, _params) do
    type_list = Fyp.Type.get_all_types()
    conn |> put_status(200) |> json(type_list)
  end
end
