import Config

config :git_ops,
  mix_project: Mix.Project.get!(),
  types: [tidbit: [hidden?: true], important: [header: "Important Changes"]],
  github_handle_lookup?: true,
  repository_url: "https://github.com/daytonn/ecto_cooler",
  version_tag_prefix: "v",
  manage_mix_version?: true,
  manage_readme_version: true

config :ecto_cooler, env: config_env()

import_config "#{config_env()}.exs"
