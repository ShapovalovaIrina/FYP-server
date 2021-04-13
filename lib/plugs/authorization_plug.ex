defmodule AuthorizationPlug do
  import Plug.Conn

  def init(options) do
    validator = Fyp.Validation.get_validator()
    [validator: validator] ++ options
  end

  def call(conn, options) do
    case Fyp.Validator.validate(options[:validator], conn, options) do
      {:ok, conn} ->
        authentication_process(conn)

      {:error, conn} ->
         unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(401, Jason.encode!(%{status: "Unauthenticated"}, pretty: true))
    |> halt()
  end

  defp authentication_process(conn) do
    case authenticated(conn) and is_verified(conn) do
      true ->
        %{
          id: conn.assigns[:authentication][:claims]["user_id"],
          email: conn.assigns[:authentication][:claims]["email"],
          name: conn.assigns[:authentication][:claims]["name"]
        }
        |> Fyp.Users.ensure_exist()
        conn

      false ->
        forbidden_access(conn)
    end
  end

  defp authenticated(conn) do
    case conn.assigns do
      %{:authentication => _} ->
        true

      _ ->
        false
    end
  end

  defp is_verified(conn) do
    conn.assigns[:authentication][:claims]["email_verified"]
  end

  def forbidden_access(conn) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(403, Jason.encode!(%{status: "Access forbidden"}, pretty: true))
    |> halt()
  end
end
