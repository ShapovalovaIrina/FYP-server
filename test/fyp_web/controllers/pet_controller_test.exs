defmodule PetControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  import FypWeb.ControllerUtils

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
      "/media/photologue/photos/xoOK2tMRMOU.jpg"]
  }

  test "Get pet list", %{conn: conn} do
    {:ok, id} = Pets.create(@data)
    c = get(conn, "/pets")
    assert json_response(c, 200) == [Map.put(@data, "id", id)]
  end

  test "Get pet by id", %{conn: conn} do
    {:ok, id} = Pets.create(@data)
    c = get(conn, "/pets/#{id}")
    assert json_response(c, 200) == Map.put(@data, "id", id)
  end
end
