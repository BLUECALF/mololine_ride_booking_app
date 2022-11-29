# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mololine,
  ecto_repos: [Mololine.Repo]

# Configures the endpoint
config :mololine, MololineWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MololineWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mololine.PubSub,
  live_view: [signing_salt: "HcX6BnSV"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :mololine, Mololine.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# In your config/config.exs file
config :mololine, Mololine.Mailer,
       adapter: Bamboo.SMTPAdapter,
       server: "smtp.gmail.com",
       port: 587,
       username: "kiptalaleonard@gmail.com" ,#SYSTEM.get_env("SMTP_USERNAME"),
       password: "tmxsaxgzlhtedvor" ,#SYSTEM.get_env("SMTP_PASSWORD"),
       tls: :if_available, # can be `:always` or `:never`
       ssl: false, # can be `true`
       retries: 3
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
