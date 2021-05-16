defmodule TypeControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  test "Get type list", %{conn: conn} do
    c = get(conn, "/types")
    type_list = json_response(c, 200)
    assert length(type_list) == 2
    assert %{"id" => _, "type" => _} = hd(type_list)
  end
end
