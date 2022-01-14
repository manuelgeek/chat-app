import Config

config :chat_app, ChatApp.Repo,
  database: "chat_app_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
