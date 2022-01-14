defmodule ChatApp.Multi do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @doc """
      executes the multi with the given `args` and `context`.
      """
      def execute(args, context, opts \\ []) do
        case new(args, context, opts) do
          {:ok, multi} ->
            case ChatApp.Repo.transaction(multi) do
              {:ok, _data} = response ->
                response

              {:error, _, _, _} = error ->
                error
            end

          {:error, error} ->
            {:error, error}
        end
      end
    end
  end
end
