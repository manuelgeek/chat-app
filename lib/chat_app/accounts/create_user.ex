defmodule ChatApp.Accounts.CreateUser do
  @moduledoc false

  alias ChatApp.Accounts.User
  alias Ecto.Multi

  use ChatApp.Multi
  import Norm

  def specs do
    schema(%{
      username: spec(is_binary()),
      email: spec(is_binary()),
      password: spec(is_binary()),
      password_confirmation: spec(is_binary())
    })
    |> selection([:username, :email, :password, :password_confirmation])
  end

  defp new(args, _context, _opts) do
    case conform(args, specs()) do
      {:ok, _} ->
        multi =
          Multi.new()
          |> Multi.put(:args, args)
          |> Multi.insert(:user, &User.create_changeset(&1.args))

        {:ok, multi}

      {:error, specs} ->
        {:error, specs}
    end
  end
end
