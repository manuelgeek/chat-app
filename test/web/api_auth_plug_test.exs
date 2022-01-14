defmodule ChatAppWeb.ApiAuthPlugTest do
  use ExUnit.Case
  use Plug.Test

  doctest ChatAppWeb.APIAuthPlug

  alias ChatAppWeb.APIAuthPlug

  alias ChatApp.{Accounts, Repo}
  alias ChatApp.Accounts.User
  alias Plug.Conn
  alias ChatApp.Router

  @opts Router.init([])

  @pow_config [otp_app: :chat_app]

  setup do
    conn = %{
      conn(:get, "/")
      | secret_key_base: String.duplicate("abcdefghijklmnopqrstuvxyz0123456789", 2)
    }

    user =
      Repo.insert!(%User{
        username: Faker.App.name(),
        email: Faker.Internet.email(),
        password_hash: "password"
      })

    {:ok, conn: conn, user: user}
  end

  test "can create, fetch, renew, and delete session", %{conn: conn, user: user} do
    assert {_res_conn, nil} = run(APIAuthPlug.fetch(conn, @pow_config))

    assert {res_conn, ^user} = run(APIAuthPlug.create(conn, user, @pow_config))

    assert %{private: %{api_access_token: access_token, api_renewal_token: renewal_token}} =
             res_conn

    assert {_res_conn, ^user} =
             run(APIAuthPlug.fetch(with_auth_header(conn, access_token), @pow_config))

    assert {res_conn, ^user} =
             run(APIAuthPlug.renew(with_auth_header(conn, renewal_token), @pow_config))

    assert %{
             private: %{
               api_access_token: renewed_access_token,
               api_renewal_token: renewed_renewal_token
             }
           } = res_conn

    assert {_res_conn, nil} =
             run(APIAuthPlug.fetch(with_auth_header(conn, access_token), @pow_config))

    assert {_res_conn, nil} =
             run(APIAuthPlug.renew(with_auth_header(conn, renewal_token), @pow_config))

    assert {_res_conn, ^user} =
             run(APIAuthPlug.fetch(with_auth_header(conn, renewed_access_token), @pow_config))

    run(APIAuthPlug.delete(with_auth_header(conn, renewed_access_token), @pow_config))
  end

  defp run({conn, value}), do: {run(conn), value}
  defp run(conn), do: Conn.send_resp(conn, 200, "")

  defp with_auth_header(conn, token), do: Plug.Conn.put_req_header(conn, "authorization", token)
end
