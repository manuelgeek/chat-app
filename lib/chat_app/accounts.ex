defmodule ChatApp.Accounts do
  @moduledoc """
  The Accounts context
  """
  import Ecto.Query, warn: false

  alias ChatApp.Accounts.{CreateUser, User}
  alias ChatApp.Repo

  @doc """
  Executes a multi to create user.
  """
  def create_user(args, context, opts \\ []),
    do: CreateUser.execute(args, context, opts)

  @doc """
  Get all users.
  """
  def fetch_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_chats(user_id) do
    Repo.all(from(u in User, where: u.id == ^user_id, join: c in assoc(u, :chats), select: c))
  end
end
