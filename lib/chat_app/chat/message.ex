defmodule ChatApp.Chat.Message do
  @moduledoc false

  alias __MODULE__

  use Ecto.Schema
  import Ecto.Changeset

  alias ChatApp.Accounts.User
  alias ChatApp.Chat.Room

  @derive {Jason.Encoder, only: [:content, :user, :inserted_at]}

  schema "chat_messages" do
    field(:content, :string)

    belongs_to(:room, Room)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def create_changeset(attrs), do: create_changeset(%Message{}, attrs)

  def create_changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:content, :room_id, :user_id])
    |> validate_required([:content, :room_id, :user_id])
  end
end
