defmodule TestController do
  @moduledoc false
  use ChatAppWeb, :controller

  def index(conn) do
    json(conn, %{message: "Hello, world!"})
  end
end
