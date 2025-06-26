defmodule EctoCooler.ResourceFunctions do
  @moduledoc false
  import Ecto.Query

  @spec change(module, Ecto.Schema.t(), map() | Keyword.t()) :: Ecto.Changeset.t()

  def change(schema, changeable, changes) do
    changeable
    |> schema.changeset(normalize_attributes(changes))
  end

  @spec changeset(module) :: Ecto.Changeset.t()

  def changeset(schema) do
    schema.changeset(struct(schema), %{})
  end

  @spec create(Ecto.Repo.t(), module, map() | Keyword.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  def create(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(normalize_attributes(attributes))
    |> repo.insert([])
  end

  @spec create!(Ecto.Repo.t(), module, map() | Keyword.t()) :: Ecto.Schema.t()

  def create!(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(normalize_attributes(attributes))
    |> repo.insert!([])
  end

  @spec delete(Ecto.Repo.t(), Ecto.Schema.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  def delete(repo, deletable) do
    deletable
    |> repo.delete([])
  end

  @spec delete!(Ecto.Repo.t(), Ecto.Schema.t()) :: Ecto.Schema.t()

  def delete!(repo, deletable) do
    deletable
    |> repo.delete!([])
  end

  @spec get(Ecto.Repo.t(), module, term(), Keyword.t()) :: Ecto.Schema.t() | nil

  def get(repo, schema, id, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get(id, [])
  end

  @spec get!(Ecto.Repo.t(), module, term(), Keyword.t()) :: Ecto.Schema.t()

  def get!(repo, schema, id, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get!(id, [])
  end

  @spec get_by(Ecto.Repo.t(), Ecto.Queryable.t(), Keyword.t() | map(), Keyword.t()) ::
          Ecto.Schema.t() | nil

  def get_by(repo, schema, attributes, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])
    repo_opts = Keyword.delete(options, :preloads)

    schema
    |> preload(^preloads)
    |> repo.get_by(attributes, repo_opts)
  end

  @spec get_by!(Ecto.Repo.t(), Ecto.Queryable.t(), Keyword.t() | map(), Keyword.t()) ::
          Ecto.Schema.t()

  def get_by!(repo, schema, attributes, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])
    repo_opts = Keyword.delete(options, :preloads)

    schema
    |> preload(^preloads)
    |> repo.get_by!(attributes, repo_opts)
  end

  @spec all(Ecto.Repo.t(), module, Keyword.t()) :: list(Ecto.Schema.t())

  def all(repo, schema, options \\ []) do
    preloads   = Keyword.get(options, :preloads, [])
    order_opts = Keyword.get(options, :order_by, [])
    conditions = Keyword.get(options, :where, [])

    query = schema
    query = if preloads == [], do: query, else: preload(query, ^preloads)
    query = if order_opts == [], do: query, else: order_by(query, ^order_opts)
    query = if conditions == [], do: query, else: where(query, ^conditions)

    repo.all(query, [])
  end

  @spec update(Ecto.Repo.t(), module, Ecto.Schema.t(), map() | Keyword.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  def update(repo, schema, updateable, attributes) do
    updateable
    |> schema.changeset(normalize_attributes(attributes))
    |> repo.update([])
  end

  @spec update!(Ecto.Repo.t(), module, Ecto.Schema.t(), map() | Keyword.t()) :: Ecto.Schema.t()

  def update!(repo, schema, updateable, attributes) do
    updateable
    |> schema.changeset(normalize_attributes(attributes))
    |> repo.update!([])
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  defp normalize_attributes(attrs) when is_list(attrs), do: Enum.into(attrs, %{})
  defp normalize_attributes(attrs), do: attrs
end
