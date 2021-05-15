defmodule OpenApi.ShelterSchema do
  alias OpenApiSpex.Schema

  defmodule Shelter do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Shelter information",
      type: :object,
      additionalProperties: false,
      properties: %{
        id: %Schema{type: :integer, description: "Shelter ID", required: true},
        title: %Schema{type: :string, description: "Shelter title", required: true},
        vk_link: %Schema{type: :string, description: "Shelter VK address"},
        site_link: %Schema{type: :string, description: "Shelter site address"}
      },
      example: %{
        "id" => 2,
        "title" => "Shelter \"Friend\"",
        "vk_link" => "https://vk.com/shelter_friend",
        "site_link" => "https://friend.ru"
      }
    })
  end

  defmodule Shelters do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Shelter list",
      type: :array,
      items: Shelter
    })
  end
end
