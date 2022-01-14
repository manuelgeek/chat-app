defmodule ChatApp.Chat.Room do
  @moduledoc false

  alias __MODULE__

  use Ecto.Schema
  import Ecto.Changeset

  alias ChatApp.Chat.{Member, Message}

  @derive {Jason.Encoder, only: [:title, :inserted_at, :id]}

  schema "chat_rooms" do
    field(:title, :string)

    has_many(:chat_members, Member)
    has_many(:messages, Message)
    has_many(:chats, through: [:chat_members, :room])

    timestamps()
  end

  @doc false
  def create_changeset(attrs), do: create_changeset(%Room{}, attrs)

  def create_changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:title])
    |> cast_assoc(:chat_members, with: &ChatApp.Chat.Member.changeset/2)
    |> validate_required([:title])
  end
end
