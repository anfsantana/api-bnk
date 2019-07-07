# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api_bnk, ecto_repos: [ApiBnK.Repo]

# Configures the endpoint
config :api_bnk, ApiBnK.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+yyPTDfUl+8TYkEi6J7ZfNeqsUqlOMQnv6mGW/XIR8a9YnRM46GtkR1Y0Q4JmjkK",
  render_errors: [view: ApiBnK.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApiBnK.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# configures Guardian
config :api_bnk, ApiBnK.Guardian,
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  issuer: "ApiBnK",
  ttl: {30, :days},
  allowed_drift: 2000,
  # optional
  verify_issuer: true,
  # generated using: JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
  secret_key: %{"k" => "yvstjS3nLJOVXi8lTUBzGA", "kty" => "oct"},
  serializer: ApiBnK.Guardian


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
