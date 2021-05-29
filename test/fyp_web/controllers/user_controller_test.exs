defmodule UserControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  alias Fyp.Users

  import FypWeb.ControllerUtils
  import Utils.TestUtils

  @user_data %{
    "id" => "123asdrfv7",
    "email" => "user@mail.com"
  }

  test "Create user", %{conn: conn} do
    authorized(conn, "user@mail.com") do
      c = post(conn, "/users")
      assert json_response(c, 201) == successful_status()
    end
  end

  test "Create (directly) and get user", %{conn: conn} do
    authorized(conn, "user@mail.com") do
      c = post(conn, "/users")
      assert json_response(c, 201) == successful_status()

      c = get(conn, "/users")
      assert json_response(c, 200) == @user_data
    end
  end

  test "Get user when not creating user directly", %{conn: conn} do
    authorized(conn, "user@mail.com") do
      c = get(conn, "/users")
      assert json_response(c, 200) == @user_data
    end
  end

  test "Delete user", %{conn: conn} do
    authorized(conn, "user@mail.com") do
      c = get(conn, "/users")
      assert json_response(c, 200) == @user_data

      c = delete(conn, "/users")
      assert json_response(c, 200) == successful_status()

      {:error, :not_found} = Users.show(Map.get(@user_data, "id"))
    end
  end

  test "Without authentication", %{conn: conn} do
    c = post(conn, "/users")
    assert json_response(c, 401) == unauthenticated()

    c = get(conn, "/users")
    assert json_response(c, 401) == unauthenticated()

    c = delete(conn, "/users")
    assert json_response(c, 401) == unauthenticated()
  end
end
