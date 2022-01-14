defmodule ChatApp.Repo.Migrations.CreateChatMembers do
  use Ecto.Migration

  def change do
    create table(:chat_members) do
      add :owner, :boolean, default: false, null: false
      add :room_id, references(:chat_rooms, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:chat_members, [:room_id])
    create index(:chat_members, [:user_id])
    create unique_index(:chat_members, [:room_id, :user_id])

    create unique_index(:chat_members, [:room_id],
             where: "owner = TRUE",
             name: "chat_members_owner"
           )
  end
end
