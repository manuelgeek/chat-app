defmodule ChatAppWeb do
  @moduledoc false

  def controller do
    quote do
      import Plug.Conn
      import ChatAppWeb.Gettext

      defp json(%{status: status} = conn, body, assigns \\ []) do
        {:ok, body} = Jason.encode(body, pretty: true)

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(status || 200, body)
        |> halt()
      end

      def translate_error({msg, opts}) do
        if count = opts[:count] do
          Gettext.dngettext(ChatAppWeb.Gettext, "errors", msg, msg, count, opts)
        else
          Gettext.dgettext(ChatAppWeb.Gettext, "errors", msg, opts)
        end
      end
    end
  end

  def router do
    quote do
      use Plug.Router

      plug(Plug.Parsers,
        parsers: [:json, :urlencoded, :multipart],
        pass: ["text/*", "application/*"],
        json_decoder: Jason
      )

      plug(ChatAppWeb.APIAuthPlug,
        otp_app: :chat_app,
        cache_store_backend: Pow.Store.Backend.MnesiaCache
      )

      plug(:match)
      plug(:dispatch)
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
