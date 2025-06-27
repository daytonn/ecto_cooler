defmodule EctoCooler.Env do
  def get(key), do: safe_get(Application.fetch_env(:ecto_cooler, key))
  def get(key, default), do: safe_get(Application.fetch_env(:ecto_cooler, key), default)
end
