defmodule ChatsController do
  @moduledoc false
  use ChatAppWeb, :controller

  alias ChatApp.{Accounts, Chats}
  alias Ecto.Changeset

  def create_chat_room(conn, %{"chat_members" => chat_members} = params) do
    user = conn.assigns[:current_user]

    params = Map.put(params, "chat_members", chat_members ++ [%{owner: true, user_id: user.id}])

    case Chats.create_chat_room(params, %{}) do
      {:ok, %{room: room}} ->
        json(conn, %{data: %{room: %{title: room.title, inserted_at: room.inserted_at}}})

      {:error, _, changeset, _} ->
        errors = Changeset.traverse_errors(changeset, &translate_error/1)

        conn
        |> put_status(422)
        |> json(%{error: %{status: 422, message: "Couldn't create chat room", errors: errors}})
    end
  end

  def fetch_chats(conn) do
    user = conn.assigns[:current_user]

    chats = Accounts.get_user_chats(user.id)
    json(conn, %{data: %{chats: chats}})
  end

  def fetch_chat(%{params: %{"id" => id}} = conn) do
    chat = Chats.get_chat_room(id)
    messages = Chats.fetch_messages(id)
    json(conn, %{data: %{chat: chat, messages: messages}})
  end

  def new_message(conn, params) do
    user = conn.assigns[:current_user]
    params = Map.put(params, "user_id", user.id)

    case Chats.create_message(params, %{}) do
      {:ok, %{message: message}} ->
        #        dispatches message to socket
        ChatApp.SocketHandler.dispatch_message(message.content, Registry.ChatApp)

        json(conn, %{data: %{room: %{content: message.content, inserted_at: message.inserted_at}}})

      {:error, _, changeset, _} ->
        errors = Changeset.traverse_errors(changeset, &translate_error/1)

        conn
        |> put_status(422)
        |> json(%{error: %{status: 422, message: "Couldn't create chat message", errors: errors}})
    end
  end
end
