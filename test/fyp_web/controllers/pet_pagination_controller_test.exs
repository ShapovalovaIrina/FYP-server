defmodule PetPaginationControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  alias Fyp.Pets

  @pet_data %{
    "name" => "Демьян",
    "photos" => ["/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg"],
    "source_link" => "http://priyut-drug.ru/take/1/416/",
    "shelter_id" => 1,
    "type_id" => 2
  }

  test "Combine filter", %{conn: conn} do
    {:ok, _} = Pets.create(@pet_data)                   # type_id: 2, shelter_id: 1
    new_pet = Map.replace(@pet_data, "type_id", 1)      # type_id: 1, shelter_id: 1
    {:ok, _} = Pets.create(new_pet)
    new_pet = Map.replace(new_pet, "shelter_id", 2)     # type_id: 1, shelter_id: 2
    {:ok, _} = Pets.create(new_pet)
    new_pet = Map.replace(new_pet, "type_id", 2)        # type_id: 2, shelter_id: 2
    {:ok, _} = Pets.create(new_pet)

    c = get(conn, "/pets/chunks")                       # request for first 10 entities
    %{"entries" => pets, "metadata" => _} = json_response(c, 200)
    assert length(pets) == 4

    c = get(conn, "/pets/chunks?limit=3")               # request for first 3 entities
    %{"entries" => pets, "metadata" => metadata} = json_response(c, 200)
    pet_0 = Enum.at(pets, 0)
    pet_1 = Enum.at(pets, 1)
    pet_2 = Enum.at(pets, 2)
    assert length(pets) == 3
    assert metadata["after"] != nil
    assert metadata["before"] == nil

    c = get(conn, "/pets/chunks?limit=3&cursor=#{metadata["after"]}") # request for last entity with cursor
    %{"entries" => pets, "metadata" => metadata} = json_response(c, 200)
    pet_4 = Enum.at(pets, 0)
    assert length(pets) == 1
    assert pet_4 != pet_0 && pet_4 != pet_1 && pet_4 != pet_2
    assert metadata["after"] == nil
    assert metadata["before"] != nil

    c = get(conn, "/pets/chunks?limit=3&cursor=#{metadata["before"]}&direction=before") # request for first 3 entities with cursor and before direction
    %{"entries" => pets, "metadata" => metadata} = json_response(c, 200)
    assert length(pets) == 3
    assert pet_2 == Enum.at(pets, 2)
    assert pet_1 == Enum.at(pets, 1)
    assert pet_0 == Enum.at(pets, 0)
    assert metadata["after"] != nil
    assert metadata["before"] == nil
  end
end
