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
        email: %Schema{type: :string, description: "Email address", format: :email},
        name: %Schema{type: :string, description: "User name", pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/}
      },
      example: %{
        "user_id" => "123asdrfv7",
        "email" => "user@mail.com",
        "name" => "Joe Jonas"
      }
    })
  end
end
