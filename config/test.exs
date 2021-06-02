use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :fyp, Fyp.Repo,
  username: "postgres",
  password: "postgres",
  database: "fyp",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fyp, FypWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only info, warnings and errors during test
config :logger, level: :info

config :fyp,
  key_source: {:system, :atom, "KEY_SOURCE", :config},
  config_users: %{
    "user@mail.com" => %{
      "email" => "user@mail.com",
      "email_verified" => true,
      "user_id" => "123asdrfv7"
    },
    "user_not_verified@mail.com" => %{
      "email" => "user@mail.com",
      "email_verified" => false,
      "user_id" => "yjnw951rfv7"
    }
  }
