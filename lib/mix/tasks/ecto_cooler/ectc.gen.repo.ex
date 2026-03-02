defmodule Mix.Tasks.Ectc.Gen.Repo do
  @shortdoc "Generate a repo, schema, and migration using EctoCooler"

  @moduledoc """
  Generate a repo, schema, and migration using EctoCooler.

  ## Usage

      mix ectc.gen.repo [repo_name] [schema_name] [table_name] [attributes...]

  ## Example

      mix ectc.gen.repo Posts Post posts title:string author:string

  This creates three files:

    - `lib/my_app/repo/posts.ex` — Repo context module with EctoCooler
    - `lib/my_app/schema/post.ex` — Ecto schema
    - `priv/repo/migrations/TIMESTAMP_create_posts.exs` — Ecto migration
  """
  @requirements ["app.config"]

  use Mix.Task

  alias EctoCooler.Templates.Repo
  alias EctoCooler.Templates.Migration
  alias EctoCooler.Templates.Schema

  @help "mix ectc.gen.repo Posts Post posts title:string"

  @impl Mix.Task
  def run([]), do: print_help()

  def run(args) when is_list(args) and length(args) < 4, do: print_help()

  def run(args) when is_list(args) do
    args
    |> Repo.create_context()
    |> print_filepath()

    [_ | rest] = args

    rest
    |> Schema.create_schema()
    |> print_filepath()

    rest
    |> Migration.create_migration()
    |> print_filepath()
  end

  defp print_help(), do: Bunt.puts([:red, "\n#{@help}"])

  defp print_filepath({:ok, filepath}), do: Mix.shell().info("* creating #{filepath}")
end
