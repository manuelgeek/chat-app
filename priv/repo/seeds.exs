# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
alias ChatApp.{Accounts, Chats}

context = %{}
password = Faker.String.base64(10)

{:ok, %{user: user1}} = Accounts.create_user(%{
  username: Faker.App.name(),
  email: Faker.Internet.email(),
  password: password,
  password_confirmation: password
}, context)

{:ok, %{user: user2}} = Accounts.create_user(%{
  username: Faker.App.name(),
  email: Faker.Internet.email(),
  password: password,
  password_confirmation: password
}, context)

#chats
{:ok, %{room: room1}} = Chats.create_chat_room( %{
  title: Faker.Lorem.word(),
  chat_members: [%{owner: true, user_id: user1.id}, %{user_id: user2.id}]
}, context)

{:ok, %{room: _room2}} = Chats.create_chat_room( %{
  title: Faker.Lorem.word(),
  chat_members: [%{owner: true, user_id: user2.id}, %{user_id: user1.id}]
}, context)

#messages for user 1 in room 1
{:ok, %{message: _message}} = Chats.create_message(%{
  room_id: room1.id,
  user_id: user1.id,
  content: Faker.Lorem.paragraph()
}, context)

{:ok, %{message: _message}} = Chats.create_message(%{
  room_id: room1.id,
  user_id: user1.id,
  content: Faker.Lorem.paragraph()
}, context)

{:ok, %{message: _message}} = Chats.create_message(%{
  room_id: room1.id,
  user_id: user1.id,
  content: Faker.Lorem.paragraph()
}, context)
