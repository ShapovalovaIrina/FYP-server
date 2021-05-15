defmodule ShelterDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Shelter

  @shelter_data %{
    title: "Test shelter",
    vk_link: "http://vk.com",
    site_link: "http://site.ru/link"
  }

  test "Create shelter" do
    {:ok, %Schemas.Shelter{id: id} = shelter} = Shelter.create(@shelter_data)
    shelter = Shelter.shelter_struct_to_shelter_map(shelter)
    expected_shelter = Map.merge(@shelter_data, %{id: id})
    assert shelter == expected_shelter
  end

  test "Duplicate shelter" do
    {:ok, %Schemas.Shelter{id: shelter_id_1} = shelter_1} = Shelter.create(@shelter_data)
    {:ok, %Schemas.Shelter{id: shelter_id_2} = shelter_2} = Shelter.create(@shelter_data)

    shelter_1 = Shelter.shelter_struct_to_shelter_map(shelter_1)
    shelter_2 = Shelter.shelter_struct_to_shelter_map(shelter_2)
    expected_shelter_1 = Map.merge(@shelter_data, %{id: shelter_id_1})
    expected_shelter_2 = Map.merge(@shelter_data, %{id: shelter_id_2})
    assert shelter_1 == expected_shelter_1
    assert shelter_2 == expected_shelter_2
    assert shelter_id_1 == shelter_id_2
  end

  test "Get all shelters" do
    shelter_list = Shelter.get_all_shelters()
    initial_length = length(shelter_list)

    {:ok, _shelter} = Shelter.create(@shelter_data)
    shelter_list = Shelter.get_all_shelters()
    assert length(shelter_list) == initial_length + 1
  end
end
