defmodule ShelterRzhevkaTest do
  use ExUnit.Case
  import Fyp.Scraping.ShelterRzhevka

  test "Correct parsing" do
    owner_id = -190703
    albums = [
      {271095019, 2} # Puppies
    ]

    pets =
      Enum.map(albums, fn {album_id, type_id} ->
        get_pets_items(owner_id, album_id)
        |> Enum.map(fn pet_item ->
          %{
            name: get_pet_name(pet_item),
            breed: nil,
            gender: nil,
            birth: nil,
            height: nil,
            description: get_pet_description(pet_item),
            photos: get_pet_photos(pet_item),
            shelter_id: 2,
            type_id: type_id
          }
        end)
      end)
      |> hd
    assert length(pets) == 16

    first_pet = hd(pets)
    assert length(first_pet[:photos]) == 1
    assert first_pet[:description] == "Лило\nг.р. 2020\n\nОпекун Яна Соловьёва\nОчень активная, шебутная девочка.\nИмеет опыт проживания в квартире."
    assert first_pet[:name] == "Лило"
  end
end
