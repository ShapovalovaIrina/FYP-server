defmodule Utils.TestUtils do
  defmacro authorized(conn, username, do: block) do
    quote do
      unquote(conn) = Plug.Conn.put_req_header(unquote(conn), "authorization", unquote(username))
      unquote(block)
    end
  end
end
