defmodule PetControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  import Utils.TestUtils
  import FypWeb.ControllerUtils

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
    "pet_type_id" => 2
  }

  @shelter_data %{
    "title" => "Shelter Friend",
    "vk_link" => "",
    "site_link" => ""
  }

  test "Get pet list", %{conn: conn} do
    {:ok, id} = Pets.create(@pet_data)
    c = get(conn, "/pets")
    expected_pet =
      @pet_data
      |> Map.merge(%{"id" => id, "shelter" => @shelter_data})
      |> Map.delete("shelter_id")
    assert json_response(c, 200) == [expected_pet]
  end

  test "Get pet by id", %{conn: conn} do
    {:ok, id} = Pets.create(@pet_data)
    c = get(conn, "/pets/#{id}")
    expected_pet =
      @pet_data
      |> Map.merge(%{"id" => id, "shelter" => @shelter_data})
      |> Map.delete("shelter_id")
    assert json_response(c, 200) == expected_pet
  end

  test "Create pet", %{conn: conn} do
    c = get(conn, "/pets")
    assert length(json_response(c, 200)) == 0

    authorized(conn, "user@mail.com") do
      c = post(conn, "/pets", @pet_data)
      assert json_response(c, 201) == successful_status()
    end

    c = get(conn, "/pets")
    assert length(json_response(c, 200)) == 1
  end

  test "Create pet with incorrect parameters", %{conn: conn} do
    c = get(conn, "/pets")
    assert length(json_response(c, 200)) == 0

    authorized(conn, "user@mail.com") do
      data =
        @pet_data
        |> Map.delete("shelter_id")
      c = post(conn, "/pets", data)
      assert json_response(c, 400) == bad_status()
    end

    c = get(conn, "/pets")
    assert length(json_response(c, 200)) == 0
  end

  test "Delete pet", %{conn: conn} do
    {:ok, id} = Pets.create(@pet_data)
    c = get(conn, "/pets/#{id}")
    expected_pet =
      @pet_data
      |> Map.merge(%{"id" => id, "shelter" => @shelter_data})
      |> Map.delete("shelter_id")
    assert json_response(c, 200) == expected_pet

    authorized(conn, "user@mail.com") do
      c = delete(conn, "/pets/#{id}")
    end

    c = get(conn, "/pets/#{id}")
    assert json_response(c, 404) == not_found_status()
  end
end
