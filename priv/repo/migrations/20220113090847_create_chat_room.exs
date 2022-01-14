defmodule ChatApp.Repo.Migrations.CreateChatRoom do
  use Ecto.Migration

  def change do
    create table :chat_rooms do
      add :title, :string, null: false

      timestamps()
    end
  end
end
