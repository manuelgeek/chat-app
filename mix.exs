defmodule ChatApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat_app,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug, :cowboy, :ecto, :postgrex],
      mod: {ChatApp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.13.3"},
      {:cowboy, "~> 2.9.0"},
      {:plug_cowboy, "~> 2.5.2"},
      {:poolboy, "~> 1.5.2"},
      {:ecto, "~> 3.7.1"},
      {:ecto_sql, "~> 3.7.1"},
      {:postgrex, "~> 0.15.13"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:faker, "~> 0.15", only: [:test, :dev]},
      {:norm, "~> 0.13.0"},
      {:jason, "~> 1.3"},
      {:pow, "~> 1.0.26"},
      {:gettext, "~> 0.11"}
    ]
  end

  defp aliases do
    [
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "seed.default"],
      "seed.default": ["run priv/repo/seeds.exs"],
      test: ["ecto.reset", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
