defmodule ChatApp.Chat.Member do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias ChatApp.Accounts.User
  alias ChatApp.Chat.Room

  @derive {Jason.Encoder, only: [:owner, :user, :room]}

  schema "chat_members" do
    field(:owner, :boolean, default: false)

    belongs_to(:user, User)
    belongs_to(:room, Room)

    timestamps()
  end

  @doc false
  def changeset(chat_member, attrs) do
    chat_member
    |> cast(attrs, [:owner, :user_id])
    |> validate_required([:owner, :user_id])
    |> unique_constraint(:user_id, name: :chat_members_room_id_user_id_index)
    |> unique_constraint(:room_id, name: :chat_members_owner)
  end
end
