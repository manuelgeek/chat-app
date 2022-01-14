defmodule ChatApp.Chat.CreateChatMessage do
  @moduledoc false

  alias ChatApp.Chat.Message
  alias Ecto.Multi

  use ChatApp.Multi

  defp new(args, _context, _opts) do
    multi =
      Multi.new()
      |> Multi.put(:args, args)
      |> Multi.insert(:message, &Message.create_changeset(&1.args))

    {:ok, multi}
  end
end
