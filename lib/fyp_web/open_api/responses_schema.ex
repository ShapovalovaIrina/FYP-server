defmodule OpenApi.ResponsesSchema do
  alias OpenApiSpex.Schema

  defmodule BadStatus do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Bad status response",
      type: :object,
      additionalProperties: false,
      properties: %{
        status: %Schema{type: :string, enum: ["Bad request"]}
      },
      example: %{
        "status" => "Bad request"
      }
    })
  end

  defmodule SuccessfulStatus do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Success response",
      type: :object,
      additionalProperties: false,
      properties: %{
        status: %Schema{type: :string, enum: ["Successfully"]}
      },
      example: %{
        "status" => "Successfully"
      }
    })
  end

  defmodule NotFoundStatus do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Not found response. Requested entity was not found.",
      type: :object,
      additionalProperties: false,
      properties: %{
        status: %Schema{type: :string, enum: ["Not found"]}
      },
      example: %{
        "status" => "Not found"
      }
    })
  end

  defmodule Unauthenticated do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Unauthenticated response. No or incorrect JWT token.",
      type: :object,
      additionalProperties: false,
      properties: %{
        status: %Schema{type: :string, enum: ["Unauthenticated"]}
      },
      example: %{
        "status" => "Unauthenticated"
      }
    })
  end

  defmodule AccessForbidden do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Access forbidden response. User has no access to requested resource.",
      type: :object,
      additionalProperties: false,
      properties: %{
        status: %Schema{type: :string, enum: ["Access forbidden"]}
      },
      example: %{
        "status" => "Access forbidden"
      }
    })
  end
end
