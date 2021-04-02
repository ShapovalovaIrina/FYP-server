defmodule PetControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  alias Fyp.Pets

  @data %{
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
    "shelter_id" => 1
  }

  @shelter_data %{
    "title" => "Shelter Friend",
    "vk_link" => "",
    "site_link" => ""
  }

  test "Get pet list", %{conn: conn} do
    {:ok, id} = Pets.create(@data)
    c = get(conn, "/pets")
    expected_pet =
      @data
      |> Map.merge(%{"id" => id, "shelter" => @shelter_data})
      |> Map.delete("shelter_id")
    assert json_response(c, 200) == [expected_pet]
  end

  test "Get pet by id", %{conn: conn} do
    {:ok, id} = Pets.create(@data)
    c = get(conn, "/pets/#{id}")
    expected_pet =
      @data
      |> Map.merge(%{"id" => id, "shelter" => @shelter_data})
      |> Map.delete("shelter_id")
    assert json_response(c, 200) == expected_pet
  end
end
