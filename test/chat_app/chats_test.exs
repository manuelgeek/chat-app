defmodule ChatApp.ChatsTest do
  use ExUnit.Case
  alias ChatApp.{Accounts, Chats, Repo}

  describe "chat module fuctions" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      %{context: %{}}
    end

    test "create chat room, message and members", %{context: context} do
      password = Faker.String.base64(10)

      user_args = %{
        username: Faker.App.name(),
        email: Faker.Internet.email(),
        password: password,
        password_confirmation: password
      }

      {:ok, %{user: user}} = Accounts.create_user(user_args, context)

      args = %{
        title: Faker.Lorem.word(),
        chat_members: [%{owner: true, user_id: user.id}]
      }

      {:ok, %{room: room}} = Chats.create_chat_room(args, context)
      assert room.title == args.title

      assert room = Chats.get_chat_room(room.id)
      assert room.title == args.title

      assert _rooms = Chats.fetch_chat_rooms()

      members = Chats.fetch_chat_room_members(room.id)

      assert is_list(members)

      message_args = %{
        room_id: room.id,
        user_id: user.id,
        content: Faker.Lorem.paragraph()
      }

      {:ok, %{message: message}} = Chats.create_message(message_args, context)

      assert message.content == message_args.content

      assert _messages = Chats.fetch_messages(room.id)

      assert _chats = Accounts.get_user_chats(user.id)
    end

    test "create chat room failure", %{context: context} do
      assert {:error, _err, _, _} = Chats.create_chat_room(%{}, context)
    end

    test "create chat message failure", %{context: context} do
      assert {:error, _err, _, _} = Chats.create_message(%{}, context)
    end
  end
end
