defmodule ChatAppWeb.SessionControllerTest do
  use ExUnit.Case

  alias ChatApp.Router
  alias ChatApp.Accounts.User
  use Plug.Test
  alias ChatApp.{Accounts, Repo}

  @password "secret1234"
  @username Faker.App.name()
  @email Faker.Internet.email()

  @opts Router.init([])

  describe "create/2" do
    %User{}
    |> User.changeset(%{
      username: @username,
      email: @email,
      password: @password,
      password_confirmation: @password
    })
    |> Repo.insert!()

    @valid_params %{
      "username" => @username,
      "email" => @email,
      "password" => @password,
      "password_confirmation" => @password
    }
    @invalid_params %{
      "email" => "invalid",
      "password" => @password,
      "password_confirmation" => ""
    }

    test "with valid params" do
      conn = conn(:post, "/login", @valid_params) |> Router.call(@opts)
      {status, _headers, json} = sent_resp(conn)
      {:ok, json} = Jason.decode(json)

      assert status === 200
      assert json["data"]["access_token"]
      assert json["data"]["renewal_token"]
    end

    test "with invalid params" do
      conn = conn(:post, "/login", @invalid_params) |> Router.call(@opts)
      {status, _headers, json} = sent_resp(conn)
      {:ok, json} = Jason.decode(json)

      assert json["error"]["message"] == "Invalid email or password"
      assert json["error"]["status"] == 401
    end
  end
end
