import Config

config :chat_app,
  ecto_repos: [ChatApp.Repo]

# pow uses phoenix deps, which we don't use in this, project, adding this to remove the warning during compile
config :phoenix, :json_library, Jason

config :chat_app, :pow,
  user: ChatApp.Accounts.User,
  repo: ChatApp.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
