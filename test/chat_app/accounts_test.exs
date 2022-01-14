defmodule ChatApp.AccountTest do
  use ExUnit.Case
  alias ChatApp.{Accounts, Repo}
  alias ChatApp.Accounts.User

  describe "create_user" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      %{context: %{}}
    end

    test "creates user successfully", %{context: context} do
      password = Faker.String.base64(10)

      args = %{
        username: Faker.App.name(),
        email: Faker.Internet.email(),
        password: password,
        password_confirmation: password
      }

      assert {:ok, %{user: user}} = Accounts.create_user(args, context)
      assert user.username == args.username
      assert user.email == args.email

      assert user = Repo.get(User, user.id)
      assert user.username == args.username
      assert user.email == args.email

      assert _users = Accounts.fetch_users()
    end

    test "create user failure", %{context: context} do
      assert {:error, _err} = Accounts.create_user(%{}, context)
    end
  end
end
