defmodule FypWeb.TestController do
  @moduledoc false

  use FypWeb, :controller
  import FypWeb.ControllerUtils

  def test_response(conn, _params) do
    IO.inspect(conn, label: "Conn in controller")
    conn |> put_status(200) |> json(successful_status())
  end

end
