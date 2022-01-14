defmodule ChatApp.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :content, :text
      add :room_id, references(:chat_rooms, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:chat_messages, [:room_id])
    create index(:chat_messages, [:user_id])
  end
end
