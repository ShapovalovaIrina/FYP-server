defmodule PetPaginationControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  alias Fyp.Pets

  @pet_data %{
    "name" => "Демьян",
    "photos" => ["/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg"],
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
    assert length(pets) == 3
    assert {2, 1} == {Enum.at(pets, 0)["type"]["id"], Enum.at(pets, 0)["shelter"]["id"]}
    assert {1, 1} == {Enum.at(pets, 1)["type"]["id"], Enum.at(pets, 1)["shelter"]["id"]}
    assert {1, 2} == {Enum.at(pets, 2)["type"]["id"], Enum.at(pets, 2)["shelter"]["id"]}
    assert metadata["after"] != nil
    assert metadata["before"] == nil

    c = get(conn, "/pets/chunks?limit=3&cursor=#{metadata["after"]}") # request for last entity with cursor
    %{"entries" => pets, "metadata" => metadata} = json_response(c, 200)
    assert length(pets) == 1
    assert {2, 2} == {Enum.at(pets, 0)["type"]["id"], Enum.at(pets, 0)["shelter"]["id"]}
    assert metadata["after"] == nil
    assert metadata["before"] != nil

    c = get(conn, "/pets/chunks?limit=3&cursor=#{metadata["before"]}&direction=before") # request for first 3 entities with cursor and before direction
    %{"entries" => pets, "metadata" => metadata} = json_response(c, 200)
    assert length(pets) == 3
    assert {2, 1} == {Enum.at(pets, 2)["type"]["id"], Enum.at(pets, 2)["shelter"]["id"]}
    assert {1, 1} == {Enum.at(pets, 1)["type"]["id"], Enum.at(pets, 1)["shelter"]["id"]}
    assert {1, 2} == {Enum.at(pets, 1)["type"]["id"], Enum.at(pets, 0)["shelter"]["id"]}
    assert metadata["after"] != nil
    assert metadata["before"] == nil
  end
end
