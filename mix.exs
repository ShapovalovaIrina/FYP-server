defmodule Fyp.MixProject do
  use Mix.Project

  def project do
    [
      app: :fyp,
      version: "0.1.2",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Fyp.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Initial phoenix app deps
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},

      # Web scraping deps
      {:httpoison, "~> 1.8"},
      {:floki, "~> 0.30.0"},

      # JWT library
      {:joken, "~> 2.3"},
      {:joken_jwks, "~> 1.4"},

      # Helper module that provides a nice way to read configuration at runtime
      # from environment variables or via adapter-supported interface
      {:confex, "~> 3.5"},

      # Open API (Swagger)
      {:open_api_spex, "~> 3.10"},

      # Pagination
      {:paginator, "~> 1.0.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/type_seeds.exs", "run priv/repo/shelter_seeds.exs", "run priv/repo/pet_seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "openapi.spec.json --spec FypWeb.ApiSpec", "run priv/repo/type_seeds.exs", "run priv/repo/shelter_seeds.exs", "test"]
    ]
  end
end
