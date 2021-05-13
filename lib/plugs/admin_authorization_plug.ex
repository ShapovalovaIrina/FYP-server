defmodule AdminAuthorizationPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, options) do
    case conn.assigns[:authentication][:claims]["firebase_group"] do
      :user -> forbidden_access(conn)
      :admin -> conn
    end
  end

  def forbidden_access(conn) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(403, Jason.encode!(%{status: "Access forbidden"}, pretty: true))
    |> halt()
  end
end
