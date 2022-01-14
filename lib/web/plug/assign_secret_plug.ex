defmodule ChatAppWeb.AssignSecretPlug do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _params) do
    assign(conn, :secret_key_base, String.duplicate("abcdefghijklmnopqrstuvxyz0123456789", 2))
    #    %{conn | secret_key_base: String.duplicate("abcdefghijklmnopqrstuvxyz0123456789", 2)}
  end
end
