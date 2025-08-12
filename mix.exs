defmodule EctoCooler.MixProject do
  use Mix.Project

  @version "2.0.7"
  def project do
    [
      aliases: aliases(),
      app: :ecto_cooler,
      deps: deps(),
      description: description(),
      dialyzer: [plt_add_apps: [:mix]],
      docs: [
        main: "readme",
        extras: ["README.md"],
        api_reference: false
      ],
      elixir: ">= 1.14.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "lib/mix/tasks"]

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp description do
    """
    A simple module to clear up the boilerplate of CRUD resources in Phoenix context files.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Dayton Nolan"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/daytonn/ecto_cooler"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger, :bunt, :eex]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bunt, "~> 1.0"},
      {:drops_inflector, "~> 0.1.0"},
      {:ecto_sql, ">= 3.13.2"},
      {:ex_doc, ">= 0.38.2", only: :dev, runtime: false},
      {:git_ops, "~> 2.0", only: [:dev], runtime: false},
      {:igniter, "~> 0.5", only: [:dev, :test]},
      {:postgrex, ">= 0.20.0", only: [:test]}
    ]
  end
end
