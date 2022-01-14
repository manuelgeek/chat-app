defmodule ChatAppWeb.TestControllerTest do
  @moduledoc false
  use ExUnit.Case
  use Plug.Test

  alias ChatApp.Router

  @opts Router.init([])

  test("/test returns 200") do
    conn = conn(:get, "/test") |> Router.call(@opts)

    {status, _headers, _body} = sent_resp(conn)
    assert status === 200
  end
end
