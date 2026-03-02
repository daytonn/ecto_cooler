defmodule Mix.Tasks.Ectc.Gen.Migration do
  @shortdoc "Generate an Ecto migration"

  @moduledoc """
  Generate an Ecto migration with more robust handling of binary ids.

  ## Usage

      mix ectc.gen.migration [schema_name] [table_name] [attributes...]

  ## Example

      mix ectc.gen.migration Post posts title:string author:string

  This creates:

    - `priv/repo/migrations/TIMESTAMP_create_posts.exs` — Ecto migration
  """
  @requirements ["app.config"]

  use Mix.Task

  alias EctoCooler.Templates.Migration

  @impl Mix.Task
  def run(args) do
    args
    |> Migration.create_migration()
    |> print_filepath()
  end

  defp print_filepath({:ok, filepath}), do: Mix.shell().info("* creating #{filepath}")
end
