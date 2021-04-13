defmodule Fyp.Token do
  @moduledoc false

  # no signer
  use Joken.Config, default_signer: nil

  @impl true
  def token_config do
    default_claims(skip: [:aud, :iss])
  end

  def before_validate(_hook_opts, {config, claims, context}) do
    config =
      config
      |> add_claim("iss", nil, &(&1 == Fyp.Token.Strategy.iss()))
      |> add_claim("aud", nil, &(&1 == Fyp.Token.Strategy.aud()))

    {:cont, {config, claims, context}}
  end
end

defmodule Fyp.Token.Strategy do
  use JokenJwks.DefaultStrategyTemplate

  def init_opts(options) do
    url = Application.get_env(:fyp, :jwks_url)
    Keyword.merge(options, jwks_url: url)
  end

  def iss() do
    Application.get_env(:fyp, :iss)
  end

  def aud() do
    Application.get_env(:fyp, :aud)
  end
end