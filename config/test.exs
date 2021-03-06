use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bible_study, BibleStudy.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Set a higher stacktrace during test
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :bible_study, BibleStudy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "bible_study_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure modules to be used
config :bible_study, :resource_sources, [BibleStudy.Sermons.Mock]
config :bible_study, :http_client, BibleStudy.HTTPClientMock
