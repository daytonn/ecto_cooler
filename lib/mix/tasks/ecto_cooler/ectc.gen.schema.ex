defmodule Mix.Tasks.Ectc.Gen.Schema do
  @shortdoc "Generate a schema module"

  @moduledoc """
  Generate a schema for use in a Phoenix application using EctoCooler

    mix ectc.gen.schema Post posts title:string
  """
  @requirements ["app.config"]

  use Mix.Task

  alias EctoCooler.Templates.Migration
  alias EctoCooler.Templates.Schema

  @impl Mix.Task
  def run(args) do
    args
    |> Schema.create_schema()
    |> print_filepath()

    args
    |> Migration.create_migration()
    |> print_filepath()
  end

  defp print_filepath({:ok, filepath}), do: Mix.shell().info("* creating #{filepath}")
end
