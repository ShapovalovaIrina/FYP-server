defmodule OpenApi.PetSchemas do
  alias OpenApiSpex.Schema

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
        shelter: OpenApi.ShelterSchema.Shelter
      }
    })
  end

  defmodule PetParameters do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pet parameters",
      type: :object,
      additionalProperties: false,
      properties: %{
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
        shelter_id: %Schema{type: :integer, description: "Pet shelter number (primary key value)", example: 1}
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

  defmodule Metadata do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Metadata for cursor-based pagination",
      type: :object,
      additionalProperties: false,
      properties: %{
        after: %Schema{type: :string, description: "An opaque cursor representing the last row of the current page"},
        before: %Schema{type: :string, description: "An opaque cursor representing the first row of the current page"},
        limit: %Schema{type: :string, description: "The maximum number of entries that can be contained in this page"},
        total_count: %Schema{type: :string, description: "The total number of entries matching the query"},
        total_count_cap_exceeded: %Schema{type: :string, description: "A boolean indicating whether the total_count_limit was exceeded"}
      },
      required: [:after, :before, :limit, :total_count, :total_count_cap_exceeded],
      example: %{
        "after" => "g3QAAAABZAACaWRhAQ==",
        "before" => "g3QAAAACZAACaWRhAWQABG5hbWVtAAAABUFsaWNl",
        "limit" => 10,
        "total_count" => "100",
        "total_count_cap_exceeded" => false
      }
    })
  end

  defmodule PetsPagination do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pet chunks with pagination metadata",
      type: :object,
      dditionalProperties: false,
      properties: %{
        entries: Pets,
        metadata: Metadata
      },
      required: [:after, :before, :limit, :total_count, :total_count_cap_exceeded],
    })
  end
end
