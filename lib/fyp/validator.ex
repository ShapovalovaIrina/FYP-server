defprotocol Fyp.Validator do
  @fallback_to_any true
  def validate(validator, conn, _opts)
  def verify_token(validator, conn)
end

defmodule Fyp.FirebaseValidator do
  defstruct [:token , :strategy]
end

defmodule Fyp.ConfigMapValidator do
  defstruct [:users]
end

defmodule Fyp.Validation do
  def get_validator() do
    {:ok, key_source} = Confex.fetch_env(:fyp, :key_source)
    get_validator(key_source)
  end

  defp get_validator(:env) do
    %Fyp.FirebaseValidator{
      token: Fyp.Token,
      strategy: Fyp.Token.Strategy
    }
  end

  defp get_validator(:config) do
    users = Confex.fetch_env!(:fyp, :config_users)
    %Fyp.ConfigMapValidator{users: users}
  end
end

# no authentication implementation
defimpl Fyp.Validator, for: Any do
  def validate(_validator, conn, _opts), do: {:ok, conn}
  def verify_token(_validator, _token), do: {:ok, []}
end

defimpl Fyp.Validator, for: Fyp.FirebaseValidator do
  require Logger

  def validate(validator, conn, _opts) do
#    IO.inspect(conn, label: "Firebase Validator, validate, conn")
    case Plug.Conn.get_req_header(conn, "authorization") do
      [] ->
        {:error, conn}

      [jwt | _] ->
        case verify_token(validator, jwt) do
          {:ok, claims} ->
#            IO.inspect(claims, label: "verify token :ok, claims")
            conn = Plug.Conn.assign(conn, :authentication, %{:claims => claims})
#            IO.inspect(conn, label: "verify token :ok, conn (assign authentication claims)")
            {:ok, conn}

          {:error, _reason} ->
            {:error, conn}
        end
    end
  end

  def verify_token(validator, jwt) do
    IO.inspect(jwt, label: "Verify token, jwt")
    token_mod = validator.token
    hooks = [
      {
        JokenJwks,
        strategy: validator.strategy
      },
      {token_mod, []}
    ]

    try do
      Joken.verify_and_validate(
        token_mod.token_config(),
        jwt,
        Joken.Signer.parse_config(:default_signer),
        %{},
        hooks
      )
    rescue
      e in Jason.DecodeError ->
        Logger.error("Jason.DecodeError error in Joken.verify_and_validate. Error: #{inspect(e)}")
        {:error, "Error in Joken.verify_and_validate"}
    end
  end
end

defimpl Fyp.Validator, for: Fyp.ConfigMapValidator do
  def validate(validator, conn, _opts) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [] ->
        {:error, conn}

      [email | _] ->
        case verify_token(validator, email) do
          {:ok, claims} ->
            {:ok, Plug.Conn.assign(conn, :authentication, %{:claims => claims})}

          _ ->
            {:error, conn}
        end
    end
  end

   def verify_token(validator, email) do
     case validator.users do
       %{^email => claims} ->
         {:ok, claims}

       _ ->
         {:error, :unauthenticated}
     end
  end
end
