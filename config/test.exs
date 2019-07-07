use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_bnk, ApiBnK.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :api_bnk, ApiBnK.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "api_bnk_test",
  pool: Ecto.Adapters.SQL.Sandbox
