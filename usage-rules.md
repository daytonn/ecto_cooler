# EctoCooler Usage Rules

## Overview
EctoCooler generates CRUD functions for Ecto schemas, reducing boilerplate in Phoenix contexts and Elixir modules. It provides a declarative API for creating standardized data access patterns.

### Basic Setup Pattern
Prefer this structure:
```elixir
defmodule MyApp.Repo.Posts do
  alias MyApp.Repo
  alias MyApp.Schema.Post

  use EctoCooler

  using_repo(Repo) do
    resource(Post)
  end
end
```

## Function Generation Options and Patterns

### Default Behavior
`resource(Post)` generates all CRUD functions without suffixes:
- `all/1`, `change/2`, `changeset/0`, `create/1`, `create!/1`, `delete/1`, `delete!/1`
- `get/2`, `get!/2`, `get_by/2`, `get_by!/2`, `update/2`, `update!/2`

### With Suffix
`resource(Post, suffix: true)` adds schema name to functions:
- `all_posts/1`, `change_post/2`, `post_changeset/0`, `create_post/1`, `get_post/2`, etc.

### Selective Generation
- `only:` - Generate specific functions: `resource(Post, only: [:create, :delete!])`
- `except:` - Generate all except specified: `resource(Post, except: [:delete, :delete!])`

### Preset Aliases
- `:read` - Read-only functions: `all/1`, `get/2`, `get!/2`, `get_by/2`, `get_by!/2`
- `:read_write` - All functions except delete: `all/1`, `change/2`, `changeset/0`, `create/1`, `create!/1`, `get/2`, `get!/2`, `get_by/2`, `get_by!/2`, `update/2`, `update!/2`
- `:write` - Data mutation functions: `change/2`, `changeset/0`, `create/1`, `create!/1`, `update/2`, `update!/2`, `delete/1`, `delete!/1`
- `:delete` - Only `delete/1` and `delete!/1`

Usage: `resource(Post, :read)`

### Query Options
Functions accept common Ecto query keyword options:

**`all/1`** accepts `preloads`, `order_by`, and `where`:
```elixir
all(preloads: [:comments])
all(order_by: [desc: :id])
all(where: [status: "published"])
all(where: [status: "published"], order_by: [asc: :title], preloads: [:author])
```

**`get/2`, `get!/2`, `get_by/2`, `get_by!/2`** accept `preloads`:
```elixir
get(1, preloads: [:author])
get_by(%{title: "Example"}, preloads: [:comments])
```

### Return Types
- `all/1` - Returns a list: `[%Post{}]`
- `get/2`, `get_by/2` - Returns struct or nil: `%Post{}` or `nil`
- `get!/2`, `get_by!/2` - Returns struct or raises: `%Post{}` or `Ecto.NoResultsError`
- `change/2` - Returns a changeset: `%Ecto.Changeset{}`
- `changeset/0` - Returns a blank changeset: `%Ecto.Changeset{}`
- `create/1`, `update/2`, `delete/1` - Returns tuple: `{:ok, %Post{}}` or `{:error, %Ecto.Changeset{}}`
- `create!/1` - Returns struct or raises: `%Post{}` or `Ecto.InvalidChangesetError`
- `update!/2` - Returns struct or raises: `%Post{}` or `Ecto.InvalidChangesetError`
- `delete!/1` - Returns struct or raises: `%Post{}` or `Ecto.StaleEntryError`

### Other notes

- EctoCooler does automatic pluralization:
  - Schema `Person` -> function `all_people/1`
  - Schema `Post` -> function `all_posts/1`
- EctoCooler-generated functions can coexist with custom functions in the same module.

## Common Mistakes to Avoid

1. Don't use `use EctoCooler` without `using_repo/1` macro
2. Don't combine `:only` and `:except` options
3. Don't expect function name customization beyond `suffix: true`
4. Don't forget to alias both Repo and Schema modules
5. Remember that configuration is only needed for generators, not runtime usage
6. Avoid using the generated `all/1` for user facing pages as it does not include filtering/pagination.

## Available mix tasks

### ectc.gen.repo
Creates repo module, schema, and migration:
```bash
mix ectc.gen.repo [repo_name] [schema_name] [table_name] [attributes...]
```

Example:
```bash
mix ectc.gen.repo Posts Post posts title:string author:string
```

Generates:
- `lib/my_app/repo/posts.ex` - Context with EctoCooler
- `lib/my_app/schema/post.ex` - Schema definition
- `priv/repo/migrations/TIMESTAMP_create_posts.exs` - Migration

### ectc.gen.schema

Generates a schema and an accompanying migration:
```bash
mix ectc.gen.schema [schema_name] [table_name] [attributes...]
```

Example:
```bash
mix ectc.gen.schema Post posts title:string author:string
```

Generates:
- `lib/my_app/schema/post.ex` - Schema definition
- `priv/repo/migrations/TIMESTAMP_create_posts.exs` - Migration

### ectc.gen.migration

Generates only an Ecto migration with more robust handling of binary ids:
```bash
mix ectc.gen.migration [schema_name] [table_name] [attributes...]
```

Example:
```bash
mix ectc.gen.migration Post posts title:string author:string
```

Generates:
- `priv/repo/migrations/TIMESTAMP_create_posts.exs` - Migration

### ecto_cooler.resources

Lists all generated resource functions for a given context module:
```bash
mix ecto_cooler.resources MyApp.Repo.Posts
```

### Attribute format

Generators accept attributes in these formats:
- `field:type` - Standard field (e.g., `title:string`, `age:integer`) with `null: false` in migration
- `field:type:null` - Nullable field (e.g., `bio:string:null`) — omits `null: false`, excluded from `validate_required`
- `field:references:table` - Foreign key (e.g., `user_id:references:users`)

Type aliases: `string` -> `:text`, `int` -> `:integer`, `bool` -> `:boolean`, `json` -> `:map`

Note: `string` maps to Postgres `:text` (not `:string`/varchar as in Phoenix generators).
