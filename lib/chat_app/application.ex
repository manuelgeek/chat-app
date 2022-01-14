defmodule ChatApp.Application do
  require Logger
  use Application

  def start(_type, _args) do
    children = [
      ChatApp.Repo,
      {Plug.Cowboy,
       scheme: :http, plug: ChatApp.Router, options: [dispatch: dispatch(), port: 4000]},
      Pow.Store.Backend.MnesiaCache,
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.ChatApp
      )
    ]

    Logger.info("app started on port 4000")

    opts = [strategy: :one_for_one, name: ChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/[...]", ChatApp.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {ChatApp.Router, []}}
       ]}
    ]
  end
end
