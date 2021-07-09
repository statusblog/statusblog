import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1
# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :statusblog, Statusblog.Repo,
  username: "postgres",
  password: "postgres",
  database: "statusblog_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :statusblog_web, StatusblogWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false

config :statusblog_site_web, StatusblogSiteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4003],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :statusblog, Statusblog.Mailer, adapter: Swoosh.Adapters.Test
