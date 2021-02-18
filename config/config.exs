# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fyp,
  ecto_repos: [Fyp.Repo]

# Configures the endpoint
config :fyp, FypWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UeV60hy/Hyp3mG/Juw+jZKRkDHP8ZTUvSc2Qoeu9OqOEgJ6v+6NCBtuwv+7rBMgI",
  render_errors: [view: FypWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Fyp.PubSub,
  live_view: [signing_salt: "aKcxVzDV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
