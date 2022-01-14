defmodule ChatApp.Chat.CreateChatRoom do
  @moduledoc false

  alias ChatApp.Chat.Room
  alias Ecto.Multi

  use ChatApp.Multi

  defp new(args, _context, _opts) do
    multi =
      Multi.new()
      |> Multi.put(:args, args)
      |> Multi.insert(:room, &Room.create_changeset(&1.args))

    {:ok, multi}
  end
end
