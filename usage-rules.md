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
- `all/1`, `change/1`, `create/1`, `create!/1`, `delete/1`, `delete!/1`
- `get/2`, `get!/2`, `get_by/2`, `get_by!/2`, `update/2`, `update!/2`

### With Suffix
`resource(Post, suffix: true)` adds schema name to functions:
- `all_posts/1`, `create_post/1`, `get_post/2`, etc.

### Selective Generation
- `only:` - Generate specific functions: `resource(Post, only: [:create, :delete!])`
- `except:` - Generate all except specified: `resource(Post, except: [:delete, :delete!])`

### Preset Aliases
- `:read` - Only `all/1`, `get/2`, `get!/2`
- `:read_write` - All except delete functions
- `:delete` - Only `delete/1` and `delete!/1`

Usage: `resource(Post, :read)`

### Query Options
Most functions accept common ecto query keyword options:
```elixir
all(preloads: [:comments])
all(order_by: [desc: :id])
all(where: [status: "published"])
get(1, preloads: [:author])
```

### Return Types
- Non-bang functions return tuples: `{:ok, result}` or `{:error, changeset}`
- Bang functions return struct or raise: `Ecto.InvalidChangesetError`, `Ecto.NoResultsError`, `Ecto.StaleEntryError`

### Other notes

- EctoCooler does automatic pluralization:
  - Schema `Person` → function `all_people/1`
  - Schema `Post` → function `all_posts/1`
- EctoCooler-generated functions can coexist with custom functions in the same module:

## Common Mistakes to Avoid

1. Don't use `use EctoCooler` without `using_repo/1` macro
2. Don't combine `:only` and `:except` options
3. Don't expect function name customization beyond `suffix: true`
4. Don't forget to alias both Repo and Schema modules
5. Remember that configuration is only needed for generators, not runtime usage
6. Avoid using the generated `all/1` for user facing pages as it does not include filtering/pagination.

## Available mix tasks:

### ectc.gen.repo
Creates repo module, schema, and migration:
```bash
mix ectc.gen.repo Posts Post posts title:string author:string
```

Generates:
- `lib/my_app/repo/posts.ex` - Context with EctoCooler
- `lib/my_app/schema/post.ex` - Schema definition
- `priv/repo/migrations/[timestamp]_create_posts.exs` - Migration

### ectc.gen.migration

Generate an Ecto migration with more robust handling of binary ids:
```bash
mix ectc.gen.migration
```


### ectc.gen.schema

Generate a schema for use in a Phoenix application using EctoCooler
```bash
mix ectc.gen.schema Post posts title:string
```

