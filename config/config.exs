# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :statusblog_site_web,
  generators: [context_app: false]

# Configures the endpoint
config :statusblog_site_web, StatusblogSiteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kGmWhQwnEwRouIo1IKpaTwpMwvnfGv99TZRawgJg4HNsRtUbfLLFkoN1CGr1LQpn",
  render_errors: [view: StatusblogSiteWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Statusblog.PubSub,
  live_view: [signing_salt: "K6H8Q7fr"]

# Configure Mix tasks and generators
config :statusblog,
  ecto_repos: [Statusblog.Repo],
  site_root_domain: "statusblog.local",
  site_port: 4001,
  site_scheme: "http",
  subdomain_denylist: ["www", "manage", "blog", "docs", "my", "statusblog", "status", "email", "meta"]

config :statusblog_web,
  ecto_repos: [Statusblog.Repo],
  generators: [context_app: :statusblog]

# Configures the endpoint
config :statusblog_web, StatusblogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hAUFG2Fusg1MRMaGEWuIK3viGG0ljuY+QrWKL7TDG9FmXedtaTR3cohSa/+fzHo9",
  render_errors: [view: StatusblogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Statusblog.PubSub,
  live_view: [signing_salt: "BVAjcel1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the mailer.
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :statusblog, Statusblog.Mailer, adapter: Swoosh.Adapters.Local

config :statusblog, Oban,
  repo: Statusblog.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# configure sentry
config :sentry,
  # dsn: set in runtime.exs
  environment_name: Mix.env(),
  included_environments: [:prod]

config :logger, Sentry.LoggerBackend,
  capture_log_messages: true,
  level: :warn,
  excluded_domains: []


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
