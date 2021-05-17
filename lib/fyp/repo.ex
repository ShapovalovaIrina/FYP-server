defmodule Fyp.Repo do
  use Ecto.Repo,
    otp_app: :fyp,
    adapter: Ecto.Adapters.Postgres

  use Paginator

  def init(_type, config) do
    config = Confex.Resolver.resolve!(config)
    {:ok, config}
  end
end
