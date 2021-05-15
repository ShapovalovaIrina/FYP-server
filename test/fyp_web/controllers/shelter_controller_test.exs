defmodule ShelterControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  import Utils.TestUtils
  import FypWeb.ControllerUtils

  @shelter_data %{
    title: "Test shelter",
    vk_link: "http://vk.com",
    site_link: "http://site.ru/link"
  }

  test "Get shelter list", %{conn: conn} do
    c = get(conn, "/shelters")
    assert length(json_response(c, 200)) != 0
    assert is_list(json_response(c, 200))
  end

  test "Create shelter", %{conn: conn} do
    c = get(conn, "/shelters")
    initial_length = length(json_response(c, 200))
    assert length(json_response(c, 200)) != 0
    assert is_list(json_response(c, 200))

    authorized(conn, "user@mail.com") do
      c = post(conn, "/shelters", @shelter_data)
      assert json_response(c, 201) == successful_status()
    end

    c = get(conn, "/shelters")
    assert length(json_response(c, 200)) == initial_length + 1
  end
end
