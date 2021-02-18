defmodule Fyp.Repo do
  use Ecto.Repo,
    otp_app: :fyp,
    adapter: Ecto.Adapters.Postgres
end
