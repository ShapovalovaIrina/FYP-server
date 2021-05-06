defmodule OpenApi.PetSchemas do
  alias OpenApiSpex.Schema

  defmodule Shelter do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Shelter base web contacts",
      type: :object,
      additionalProperties: false,
      properties: %{
        title: %Schema{type: :string, description: "Shelter title", example: "Shelter Friend"},
        vk_link: %Schema{type: :string, description: "Shelter VK link", example: "https://vk.com/paperpaper_ru"},
        site_link: %Schema{type: :string, description: "Shelter site link", example: "https://yandex.ru/"}
      }
    })
  end

  defmodule Pet do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pet information",
      type: :object,
      additionalProperties: false,
      properties: %{
        id: %Schema{type: :string, description: "Pet id", example: "123e4567-e89b-12d3-a456-426655440000"},
        name: %Schema{type: :string, description: "Pet name", example: "Rex"},
        breed: %Schema{type: :string, description: "Pet breed", example: "Metis"},
        gender: %Schema{type: :string, description: "Pet gender: male, female", example: "male"},
        birth: %Schema{type: :string, description: "Pet birth date", example: "20 June 2018"},
        height: %Schema{type: :string, description: "Pet height", example: "50 cm"},
        description: %Schema{type: :string, description: "Full description of the pet", example: "Rex is a friendly and intelligent dog. He'll be a great friend."},
        photos: %Schema{type: :array, items: %Schema{
          title: "PetPhoto",
          description: "Pet photo URL",
          type: :string,
          example: "/media/photologue/photos/VTzN9xCbeWg.jpg"
        }},
        shelter: Shelter
      }
    })
  end

  defmodule Pets do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pet list",
      type: :array,
      items: Pet
    })
  end

  defmodule PetsIds do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pet list (id only)",
      type: :array,
      items: %Schema{type: :string, description: "Pet id", example: "123e4567-e89b-12d3-a456-426655440000"}
    })
  end
end
