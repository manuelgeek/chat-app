defmodule ChatApp.Accounts.User do
  @moduledoc false

  @derive {Jason.Encoder, only: [:username, :email]}

  alias __MODULE__

  import Ecto.Changeset

  use Ecto.Schema
  use Pow.Ecto.Schema

  alias ChatApp.Chat.Member

  schema "users" do
    field(:username, :string)
    pow_user_fields()

    timestamps(type: :utc_datetime)

    has_many(:chat_members, Member)
    has_many(:chats, through: [:chat_members, :room])
  end

  @doc false
  def create_changeset(attrs), do: changeset(%User{}, attrs)

  def changeset(user, attrs) do
    user
    |> pow_changeset(attrs)
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
