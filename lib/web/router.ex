defmodule ChatApp.Router do
  use ChatAppWeb, :router

  require Logger

  get "/" do
    conn
    |> send_resp(200, "Hello World")
    |> halt()
  end

  get "/test" do
    TestController.index(conn)
  end

  post "/register" do
    RegistrationController.create(conn, conn.params)
  end

  post "/login" do
    LoginController.create(conn, conn.params)
  end

  post "/logout" do
    LoginController.delete(conn, conn.params)
  end

  post "/login/renew" do
    LoginController.renew(conn, conn.params)
  end

  #  protected routes, figure this out , implement scope
  plug(Pow.Plug.RequireAuthenticated, error_handler: ChatAppWeb.APIAuthErrorHandler)

  post "/chats/create" do
    ChatsController.create_chat_room(conn, conn.params)
  end

  get "/chats" do
    ChatsController.fetch_chats(conn)
  end

  get "/chat/:id" do
    ChatsController.fetch_chat(conn)
  end

  post "/chat/message" do
    ChatsController.new_message(conn, conn.params)
  end

  match(_, do: conn |> send_resp(404, "404 error not found") |> halt())
end
