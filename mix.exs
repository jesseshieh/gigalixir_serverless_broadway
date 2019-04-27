defmodule GigalixirServerlessBroadway.MixProject do
  use Mix.Project

  def project do
    [
      app: :gigalixir_serverless_broadway,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {GigalixirServerlessBroadway.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway, "~> 0.1.0"},
      {:broadway_sqs, "~> 0.1.0"},
      {:hackney, "~> 1.9"}
    ]
  end
end
