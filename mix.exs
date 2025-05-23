defmodule PingPong.MixProject do
  use Mix.Project

  def project do
    [
      app: :ping_pong,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :castore, :retry],
      mod: {PingPong.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~>2.7.2"},
      {:jason, "~>1.4.4"},
      {:req, "~>0.5.0"},
      {:cachex, "~>4.0.2"},
      {:castore, "~> 1.0"},
      {:retry, "~> 0.18"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.15", only: :test},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
