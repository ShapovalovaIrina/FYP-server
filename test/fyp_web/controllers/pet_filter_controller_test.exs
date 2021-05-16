defmodule PetFilterControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  alias Fyp.Pets

  @pet_data %{
    "name" => "Демьян",
    "breed" => "метис",
    "gender" => "мальчик",
    "birth" => "Июл 2020",
    "height" => "50 см",
    "description" => "Общительный, ласковый песик.",
    "photos" => ["/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg",
      "/media/photologue/photos/_ncHhW9vlX4.jpg",
      "/media/photologue/photos/jpMWEsPU9VI.jpg",
      "/media/photologue/photos/KHqFllxPeAk.jpg",
      "/media/photologue/photos/xoOK2tMRMOU.jpg"],
    "shelter_id" => 1,
    "type_id" => 2
  }

  test "Filter by type", %{conn: conn} do
    {:ok, _} = Pets.create(@pet_data)
    new_pet = Map.replace(@pet_data, "type_id", 1)
    {:ok, _} = Pets.create(new_pet)

    c = get(conn, "/pets")
    assert length(json_response(c, 200)) == 2

    c = get(conn, "/pets?type_id=1")
    assert length(json_response(c, 200)) == 1

    c = get(conn, "/pets?type_id=1,2")
    assert length(json_response(c, 200)) == 2
  end

  test "Filter by shelter", %{conn: conn} do
    {:ok, _} = Pets.create(@pet_data)
    new_pet = Map.replace(@pet_data, "shelter_id", 2)
    {:ok, _} = Pets.create(new_pet)

    c = get(conn, "/pets")
    assert length(json_response(c, 200)) == 2

    c = get(conn, "/pets?shelter_id=1")
    assert length(json_response(c, 200)) == 1

    c = get(conn, "/pets?shelter_id=1,2")
    assert length(json_response(c, 200)) == 2
  end

  test "Combine filter", %{conn: conn} do
    {:ok, _} = Pets.create(@pet_data) # type_id: 2, shelter_id: 1
    new_pet = Map.replace(@pet_data, "shelter_id", 2) # type_id: 2, shelter_id: 2
    {:ok, _} = Pets.create(new_pet)
    new_pet = Map.replace(new_pet, "type_id", 1) # type_id: 1, shelter_id: 2
    {:ok, _} = Pets.create(new_pet)

    c = get(conn, "/pets")
    assert length(json_response(c, 200)) == 3

    c = get(conn, "/pets?shelter_id=2&type_id=1")
    assert length(json_response(c, 200)) == 1
  end
end
