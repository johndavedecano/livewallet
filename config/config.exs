# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :walletapp,
  ecto_repos: [Walletapp.Repo]

# Configures the endpoint
config :walletapp, WalletappWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: WalletappWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Walletapp.PubSub,
  live_view: [signing_salt: "FtKyhK0i"],
  pusbsub: [
    name: Walletapp.PubSub,
    adapter: Phoenix.PubSub.Redis,
    host: "localhost",
    port: 6379
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :walletapp, Walletapp.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "localhost",
  username: "",
  password: "",
  ssl: false,
  tls: :never,
  port: 1025,
  retries: 1

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "exq",
  concurrency: :infinite,
  queues: ["default"],
  poll_timeout: 50,
  scheduler_poll_timeout: 200,
  scheduler_enable: true,
  max_retries: 25,
  mode: :default,
  shutdown_timeout: 5000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
