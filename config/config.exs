# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :zizhixi,
  ecto_repos: [Zizhixi.Repo]

# Configures the endpoint
config :zizhixi, Zizhixi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "irEC/Gss1ZZksuSdtpUnUbfaESiDfRw1/I4PEgqsNRIUrDwcIVM/cTecRycavZrV",
  render_errors: [view: Zizhixi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Zizhixi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

config :guardian, Guardian,
  issuer: "Zizhixi.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  secret_key: to_string(Mix.env),
  serializer: Zizhixi.Guardian.Serializer,
  permissions: %{
    default: [:all],
    admin: [:all]
  }

config :scrivener_html,
  routes_helper: Zizhixi.Router.Helpers

config :qiniu, Qiniu,
  access_key: "TclBVGU4r4VVciPqHuUMyEev5COSNg8ikfl7-duS",
  secret_key: "kO6GQq13bE-qRrXJ53gdC6xdiXFr0HlQS2HXVlmF"

config :aliyun_direct_mail, AliyunDirectMail,
  access_key_id: "LTAItVgpcvajonWo",
  access_key_secret: "2ltc7OnwcIKFf88RGmLsl011wBDOp6"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
