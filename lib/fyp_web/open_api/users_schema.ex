defmodule OpenApi.UsersSchema do
  alias OpenApiSpex.Schema

  defmodule User do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User information",
      type: :object,
      additionalProperties: false,
      properties: %{
        user_id: %Schema{type: :string, description: "User ID"},
        email: %Schema{type: :string, description: "Email address", format: :email}
      },
      example: %{
        "user_id" => "123asdrfv7",
        "email" => "user@mail.com"
      }
    })
  end
end
