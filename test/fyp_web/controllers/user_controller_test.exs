defmodule UserControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  import FypWeb.ControllerUtils
  alias Fyp.Users

  @user_data %{
    name: "Username",
    email: "user@mail.com"
  }

  test "Create user", %{conn: conn} do
    c = post(conn, "/users", @user_data)
    assert json_response(c, 201) == successful_status()
  end
end
