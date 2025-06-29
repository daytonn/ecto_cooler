# EctoCooler

![Ecto Cooler Logo](https://github.com/daytonn/ecto_cooler/blob/2d89eeaf1de6b4c9f754a2f48756e4da5ff9015f/mascott.png)

- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Basic usage](#basic-usage---generate-all-ectoresource-functions)
  - [Explicit usage](#explicit-usage---generate-only-given-functions)
  - [Exclusive usage](#exclusive-usage---generate-all-but-the-given-functions)
  - [Alias :read](#alias-read---generate-data-access-functions)
  - [Alias :read_write](#alias-read_write---generate-data-access-and-manipulation-functions-excluding-delete)
  - [Resource functions](#resource-functions)
  - [Generators](#generators)
- [Caveats](#caveats)
- [Contribution](#contribution)
  - [Bug reports](#bug_reports)
  - [Pull requests](#pull_requests)
- [Release Workflow](#release-workflow)
  - [Branch Naming Convention](#branch-naming-convention)
  - [What Happens on Merge](#what-happens-on-merge)
  - [Skipping Releases](#skipping-releases)
  - [Manual Releases](#manual-releases)
- [License](#license)
- [Authors](#authors)

Eliminate boilerplate involved in defining basic CRUD functions in a Phoenix context or Elixir module.

## About

When using [Context modules](https://hexdocs.pm/phoenix/contexts.html) in a Phoenix application, there's a general need to define standard CRUD functions for a given `Ecto.Schema`. Phoenix context generators can even do this automatically. However, you'll soon notice that there's quite a lot of code involved in CRUD access within your contexts.

This can become problematic for several reasons:

- Boilerplate functions for CRUD access, for every `Ecto.Schema` referenced in that context, introduce more noise than signal. This can obscure the more interesting details of the context.
- These functions may tend to drift from the standard API by inviting edits for new use-cases, reducing the usefulness of naming conventions.
- The burden of locally testing wrapper functions yields low value compared to the investment in writing and maintaining them.

In short, at best, this code is redundant and at worst is a deviant entanglement of modified conventions. All of which amounts to a more-painful development experience. `EctoCooler` was created to ease this pain.

## Features

- ### Generate CRUD functions for a given `Ecto.Repo` and `Ecto.Schema`

  - `EctoCooler` can be used to generate CRUD functions for a given `Ecto.Repo` and `Ecto.Schema`. By default it will create every function needed to create, read, update, and delete the resource. It includes the `!` variant of each function (where relevant) that raises on failure rather than returning an error tuple.

- ### Allow customization of generated resources

  - You can optionally include or exclude specific functions to generate exactly the functions your context requires. There are also handy aliases (`:read`, `:read_write`, `:delete`) for quickly generating common subsets of functions.

- ### Automatic pluralization

  - `EctoCooler` uses `Inflex` when generating functions to create readable english function names automatically. For example, given the schema `Person`, a function named `all_people/1` is generated.

- ### Generate documentation for each generated function

  - Every function generated includes documentation so your application's documentation will include the generated functions with examples.

- ### Supports any module
  - While `EctoCooler` was designed for [Phoenix Contexts](https://hexdocs.pm/phoenix/contexts.html) in mind, It can be used in any Elixir module to access Ecto-based back-ends.

## Installation

This package is available in [Hex](https://hex.pm/), the package can be installed by adding ecto_cooler to your list of dependencies in mix.exs:

```elixir
    def deps do
      [
        # Use the latest 2.x release
        {:ecto_cooler, "~> 2.0"}
      ]
    end
```

## Configuration

The bare minimum app config is an `app_name` and an `app_slug`. These are only necessary if you are using generators. Otherwise there is no configuration necessary.

```elixir
config :ecto_cooler,
  app_name: "MyApp",
  app_slug: :my_app
```

Configuration is only necessary if you intend to use the generators for Phoenix applications. The full config is as follows:

```elixir
config :ecto_cooler,
    app_name: "MyApp",
    app_slug: :my_app,
    generators: [binary_id: true],
    migration_dir: "priv/repo/migrations",
    repo_dir: "lib/my_app/repo",
    repo_namespace: "Repo",
    schema_dir: "lib/my_app/schema",
    schema_namespace: "Schema"
```

_NOTE: If `binary_id` is configured in your Phoenix configuration and you have `app_slug` defined in your `ecto_cooler` configuration, you don't need to specify the `generators: [binary_id: true]` in the `ecto_cooler` config since it will be picked up from the Phoenix configuration._

## Usage

### Basic usage - generate all `EctoCooler` functions

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

This generates all the functions `EctoCooler` has to offer:

- `MyApp.Repo.Posts.all/1`
- `MyApp.Repo.Posts.change/1`
- `MyApp.Repo.Posts.create/1`
- `MyApp.Repo.Posts.create!/1`
- `MyApp.Repo.Posts.delete/1`
- `MyApp.Repo.Posts.delete!/1`
- `MyApp.Repo.Posts.get/2`
- `MyApp.Repo.Posts.get!/2`
- `MyApp.Repo.Posts.get_by/2`
- `MyApp.Repo.Posts.get_by!/2`
- `MyApp.Repo.Posts.update/2`
- `MyApp.Repo.Posts.update!/2`

If you want the functions to be namespaced, you can use the `suffix: true` option.

```elixir
defmodule MyApp.Repo.Posts do
  alias MyApp.Repo
  alias MyApp.Schema.Post

  use EctoCooler

  using_repo(Repo) do
    resource(Post, suffix: true)
  end
end
```

This generates all the functions `EctoCooler` with a suffix:

- `MyApp.Repo.Posts.all_posts/1`
- `MyApp.Repo.Posts.change_post/1`
- `MyApp.Repo.Posts.create_post/1`
- `MyApp.Repo.Posts.create_post!/1`
- `MyApp.Repo.Posts.delete_post/1`
- `MyApp.Repo.Posts.delete_post!/1`
- `MyApp.Repo.Posts.get_post/2`
- `MyApp.Repo.Posts.get_post!/2`
- `MyApp.Repo.Posts.get_post_by/2`
- `MyApp.Repo.Posts.get_post_by!/2`
- `MyApp.Repo.Posts.update_post/2`
- `MyApp.Repo.Posts.update_post!/2`

### Explicit usage - generate only given functions

```elixir
defmodule MyApp.Repo.Posts do
  alias MyApp.Repo
  alias MyApp.Schema.Post

  use EctoCooler

  using_repo(Repo) do
    resource(Post, only: [:create, :delete!])
  end
end
```

This generates only the given functions:

- `MyApp.Repo.Posts.create/1`
- `MyApp.Repo.Posts.delete!/1`

### Exclusive usage - generate all but the given functions

```elixir
defmodule MyApp.Repo.Posts do
  alias MyApp.Repo
  alias MyApp.Schema.Post

  use EctoCooler

  using_repo(Repo) do
    resource(Post, except: [:create, :delete!])
  end
end
```

This generates all the functions excluding the given functions:

- `MyApp.Repo.Posts.all/1`
- `MyApp.Repo.Posts.change/1`
- `MyApp.Repo.Posts.create!/1`
- `MyApp.Repo.Posts.delete/1`
- `MyApp.Repo.Posts.get/2`
- `MyApp.Repo.Posts.get_by/2`
- `MyApp.Repo.Posts.get_by!/2`
- `MyApp.Repo.Posts.get!/2`
- `MyApp.Repo.Posts.update/2`
- `MyApp.Repo.Posts.update!/2`

### Alias `:read` - generate data access functions

```elixir
defmodule MyApp.Repo.Posts do
  alias MyApp.Repo
  alias MyApp.Schema.Post

  use EctoCooler

  using_repo(Repo) do
    resource(Post, :read)
  end
end
```

This generates all the functions necessary for reading data:

- `MyApp.Repo.Posts.all/1`
- `MyApp.Repo.Posts.get/2`
- `MyApp.Repo.Posts.get!/2`

### Alias `:read_write` - generate data access and manipulation functions, excluding delete

```elixir
defmodule MyApp.Repo.Posts do
  alias MyApp.Repo
  alias MyApp.Schema.Post

  use EctoCooler

  using_repo(Repo) do
    resource(Post, :read_write)
  end
end
```

This generates all the functions except `delete/1` and `delete!/1`:

- `MyApp.Repo.Posts.all/1`
- `MyApp.Repo.Posts.change/1`
- `MyApp.Repo.Posts.create/1`
- `MyApp.Repo.Posts.create!/1`
- `MyApp.Repo.Posts.get/2`
- `MyApp.Repo.Posts.get!/2`
- `MyApp.Repo.Posts.update/2`
- `MyApp.Repo.Posts.update!/2`

### Alias `:delete` – generate only delete helpers

```elixir
defmodule MyApp.Repo.Posts do
  alias MyApp.Repo
  alias MyApp.Schema.Post

  use EctoCooler

  using_repo(Repo) do
    resource(Post, :delete)
  end
end
```

Generated functions:

- `MyApp.Repo.Posts.delete/1`
- `MyApp.Repo.Posts.delete!/1`

### Resource functions

The general idea of the generated resource functions is to abstract away the `Ecto.Repo` and `Ecto.Schema` parts of data access with `Ecto` and provide an API to the context that feels natural and clear to the caller.

The following examples will all assume a repo named `Posts` and a schema named `Post`.

#### Resource.all

Fetches a list of all %Post{} entries from the data store. _Note: `EctoCooler` will pluralize this function name using `Inflex`_

```elixir
iex> Posts.all()
[%Post{id: 1}]

iex> Posts.all(preloads: [:address])
[%Post{id: 1, comment: %Comment{}}]

iex> Posts.all(order_by: [desc: :id])
[%Post{id: 2}, %Post{id: 1}]

iex> Posts.all(preloads: [:comment], order_by: [desc: :id]))
[
  %Post{
    id: 2,
    comment: %Comment{}
  },
  %Post{
    id: 1,
    comment: %Comment{}
  }
]

iex> Posts.all(where: [category: "Testing"])
[
  %Post{
    id: 42,
    category: "Testing"
  },
  %Post{
    id: 99,
    category: "Testing"
  }
]
```

#### Posts.change

Creates a `%Post{}` changeset.

```elixir
iex> Posts.change(%{title: "Example Post"})
#Ecto.Changeset<
  action: nil,
  changes: %{title: "Example Post"},
  errors: [],
  data: #Post<>,
  valid?: true
>
```

#### Posts.create

Inserts a `%Post{}` with the given attributes in the data store, returning an `:ok`/`:error` tuple.

```elixir
iex> Posts.create(%{title: "Example Post"})
{:ok, %Post{id: 123, title: "Example Post"}}

iex> Posts.create(%{invalid: "invalid"})
{:error, %Ecto.Changeset}
```

#### Posts.create!

Inserts a `%Post{}` with the given attributes in the data store, returning a `%Post{}` or raises `Ecto.InvalidChangesetError`.

```elixir
iex> Posts.create!(%{title: "Example Post"})
%Post{id: 123, title: "Example Post"}

iex> Posts.create!(%{invalid: "invalid"})
** (Ecto.InvalidChangesetError)
```

#### Posts.delete

Deletes a given `%Post{}` from the data store, returning an `:ok`/`:error` tuple.

```elixir
iex> Posts.delete(%Post{id: 1})
{:ok, %Post{id: 1}}

iex> Posts.delete(%Post{id: 999})
{:error, %Ecto.Changeset}
```

#### Posts.delete!

Deletes a given `%Post{}` from the data store, returning the deleted `%Post{}`, or raises `Ecto.StaleEntryError`.

```elixir
iex> Posts.delete!(%Post{id: 1})
%Post{id: 1}

iex> Posts.delete!(%Post{id: 999})
** (Ecto.StaleEntryError)
```

#### Posts.get

Fetches a single `%Post{}` from the data store where the primary key matches the given id, returns a `%Post{}` or `nil`.

```elixir
iex> Posts.get(1)
%Post{id: 1}

iex> Posts.get(999)
nil

iex> Posts.get(1, preloads: [:address])
%Post{
    id: 1,
    address: %Address{}
}
```

#### Posts.get!

Fetches a single `%Post{}` from the data store where the primary key matches the given id, returns a `%Post{}` or raises `Ecto.NoResultsError`.

```elixir
iex> Posts.get!(1)
%Post{id: 1}

iex> Posts.get!(999)
** (Ecto.NoResultsError)

iex> Posts.get!(1, preloads: [:comments])
%Post{
    id: 1,
    comments: [%Comment{}],
    ...
}
```

#### Posts.get_by

Fetches a single `%Post{}` from the data store where the attributes match the
given values.

```elixir
iex> Posts.get_by(%{title: "Example Title"})
%Post{title: "Example Title"}

iex> Posts.get_by(%{title: "Doesn't Exist"})
nil
```

#### Posts.get_by!

Fetches a single `%Post{}` from the data store where the attributes match the
given values. Raises an `Ecto.NoResultsError` if the record does not exist

```elixir
iex> Posts.get_by!(%{title: "Example Title"})
%Post{title: "Example Title"}

iex> Posts.get_by!(%{title: "Doesn't Exist"})
** (Ecto.NoResultsError)
```

#### Posts.update

Updates a given `%Post{}` with the given attributes, returning an `{:ok, %Post{}}` or `{:error, Ecto.Changeset}` tuple.

```elixir
iex> Posts.update(%Post{id: 1}, %{title: "Updated Title"})
{:ok, %Post{id: 1, title: "Updated Title"}}

iex> Posts.update(%Post{id: 1}, %{invalid: "invalid"})
{:error, %Ecto.Changeset}
```

#### Posts.update!

Updates a given `%Post{}` with the given attributes, returning a `%Post{}` or raising `Ecto.InvalidChangesetError`.

```elixir
iex> Posts.update!(%Post{id: 1}, %{title: "Updated Title"})
%Post{id: 1, title: "Updated Title"}

iex> Posts.update!(%Post{id: 1}, %{invalid: "invalid"})
** (Ecto.InvalidChangesetError)
```

## Generators

Generators are basically `EctoCooler` replacements for Phoenix Context and Schema generators.

### mix ectc.gen.repo

This generator will generate a Repo module, a Schema module, and a Migration file with the given options. The options from left to right are: [repo name] [schema name] [table name] [attributes]

```bash

mix ectc.gen.repo Posts Post posts title:string author:string

```

This will create the following files:

```bash
/lib/my_app/repo/posts.ex
/lib/my_app/schema/post.ex
lib/priv/repo/migrations/00000000000000000_create_posts.exs

```

## Caveats

This package is meant to bring a lot of "out-of-the-box" basic functionality for working with Ecto schemas/queries and reducing boilerplate. Some contexts may never need to have anything more than EctoCooler while others will accumulate many custom queries/commands. EctoCooler is a lightweight foundation which can be built upon or worked around completely. _Be wary of your use of `all()`_.

## Contribution

### Bug reports

If you discover any bugs, feel free to create an issue on [GitHub](https://github.com/daytonn/ecto_cooler/issues). Please add as much information as possible to help in fixing the potential bug. You are also encouraged to help even more by forking and sending us a pull request.

[Issues on GitHub](https://github.com/daytonn/ecto_cooler/issues)

### Pull requests

- Fork it (https://github.com/daytonn/ecto_cooler/fork)
- Add upstream remote (`git remote add upstream git@github.com:daytonn/ecto_cooler.git`)
- Make sure you're up-to-date with upstream main (`git pull upstream main`)
- Create your feature branch (`git checkout -b feature/fooBar`)
- Commit your changes (`git commit -am 'Add some fooBar'`)
- Push to the branch (`git push origin feature/fooBar`)
- Create a new Pull Request

### Nice to have features/improvements (:point_up::wink:)

- Ability to override pluralization

## Release Workflow

This project uses a conventional commit-based release workflow that automatically creates releases when pull requests are merged to the main branch.

### Branch Naming Convention

To trigger a release, your branch name must follow the conventional commit format:

- **Major version bump**: `major/description` or `breaking/description`
  - Example: `major/breaking-api-changes`
- **Minor version bump**: `minor/description` or `feature/description`
  - Example: `feature/add-new-generator`
- **Patch version bump**: `patch/description`, `fix/description`, `bugfix/description`, or `hotfix/description`
  - Example: `fix/resolve-version-parsing-issue`

### What Happens on Merge

When a pull request with a conventional commit branch name is merged to main:

1. **Version Detection**: The workflow analyzes the branch name to determine the version bump type
2. **Version Update**: Updates the version in `mix.exs` according to semantic versioning
3. **Changelog Update**: 
   - Creates a new version entry in `CHANGELOG.md`
   - Adds the PR title to the appropriate section (Added/Changed/Fixed)
4. **Release Tag**: Creates and pushes a git tag with the new version
5. **Commit**: Commits the version and changelog changes to main

### Skipping Releases

If your branch doesn't follow the conventional commit naming pattern, no release will be created. This is useful for:
- Documentation updates
- Test improvements
- CI/CD changes
- Any changes that don't warrant a version bump

### Manual Releases

For manual releases or when the automated workflow isn't suitable, you can:
1. Create a branch with the appropriate prefix (e.g., `patch/manual-release`)
2. Make your changes
3. Create a pull request
4. Merge to trigger the release

## License

[Apache 2.0](https://raw.githubusercontent.com/daytonn/ecto_cooler/main/LICENSE.txt)

```

```
