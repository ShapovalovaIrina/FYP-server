defmodule OpenApi.TypeSchema do
  alias OpenApiSpex.Schema

  defmodule Type do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pet type information",
      type: :object,
      additionalProperties: false,
      properties: %{
        id: %Schema{type: :integer, description: "Type ID"},
        type: %Schema{type: :string, description: "Pet type"}
      },
      required: [:id, :type],
      example: %{
        "id" => 1,
        "title" => "Котик",
      }
    })
  end

  defmodule Types do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Type list",
      type: :array,
      items: Type
    })
  end
end
