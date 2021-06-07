# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :statusblog,
  ecto_repos: [Statusblog.Repo]

# Configures the endpoint
config :statusblog, StatusblogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2zS97thTQXa5Lw5VqvtGfRhPwQrz65CP187hoRwH0fCxbORWRCkIcyp7NY23bSUJ",
  render_errors: [view: StatusblogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Statusblog.PubSub,
  live_view: [signing_salt: "hBa4TN9j"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
