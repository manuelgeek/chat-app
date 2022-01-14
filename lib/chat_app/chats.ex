defmodule ChatApp.Chats do
  @moduledoc false

  import Ecto.Query, warn: false

  alias ChatApp.Repo
  alias ChatApp.Chat.{Room, CreateChatRoom, Message, CreateChatMessage, Member}

  def fetch_chat_rooms do
    Repo.all(Room)
  end

  def get_chat_room(room_id) do
    Repo.get(Room, room_id)
  end

  def fetch_messages(room_id) do
    Repo.all(
      from(m in Message,
        where: m.room_id == ^room_id,
        preload: :user,
        order_by: [desc: :inserted_at]
      )
    )
  end

  def fetch_chat_room_members(room_id) do
    Repo.all(
      from(m in Member,
        where: m.room_id == ^room_id,
        preload: :user,
        order_by: [desc: :inserted_at]
      )
    )
  end

  def create_chat_room(args, context, opts \\ []),
    do: CreateChatRoom.execute(args, context, opts)

  def create_message(args, context, opts \\ []),
    do: CreateChatMessage.execute(args, context, opts)
end
