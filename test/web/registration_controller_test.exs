defmodule ChatAppWeb.RegistrationControllerTest do
  use ExUnit.Case

  alias ChatApp.Router
  use Plug.Test

  @password "secret1234"

  @opts Router.init([])

  describe "create/2" do
    @valid_params %{
      "username" => Faker.App.name(),
      "email" => Faker.Internet.email(),
      "password" => @password,
      "password_confirmation" => @password
    }
    @invalid_params %{
      "email" => "invalid",
      "password" => @password,
      "password_confirmation" => ""
    }

    test "with valid params" do
      conn = conn(:post, "/register", @valid_params) |> Router.call(@opts)
      {status, _headers, json} = sent_resp(conn)
      {:ok, json} = Jason.decode(json)

      assert status === 200
      assert json["data"]["access_token"]
      assert json["data"]["renewal_token"]
    end

    test "with invalid params" do
      conn = conn(:post, "/register", @invalid_params) |> Router.call(@opts)
      {status, _headers, json} = sent_resp(conn)
      {:ok, json} = Jason.decode(json)

      assert status === 422
      assert json["error"]["message"] == "Couldn't create user"
      assert json["error"]["status"] == 422
      assert json["error"]["errors"]["password_confirmation"] == ["does not match confirmation"]
      assert json["error"]["errors"]["email"] == ["has invalid format"]
    end
  end
end
