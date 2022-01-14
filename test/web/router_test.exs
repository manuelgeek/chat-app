defmodule ChatAppWeb.RouterTest do
  @moduledoc false
  use ExUnit.Case
  use Plug.Test

  alias ChatApp.Router

  @opts Router.init([])

  test("index returns 200") do
    conn = conn(:get, "/") |> Router.call(@opts)

    {status, _headers, body} = sent_resp(conn)
    assert status === 200
    assert body === "Hello World"
  end

  test("404 page") do
    conn = conn(:get, "/404") |> Router.call(@opts)

    {status, _headers, body} = sent_resp(conn)
    assert status === 404
    assert body === "404 error not found"
  end
end
