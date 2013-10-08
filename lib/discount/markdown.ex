defmodule Discount.Markdown do

  def parse_doc_list(documents, callback) do
    result_list = documents |> Parallel.map fn(document) ->
      current = self

      parse_doc document, fn(result) ->
        current <- {:parsed, result}
      end

      receive do
        {:parsed, {status, result}} ->
          case status do
            :ok    -> result
            :error -> false
          end

        _ -> false
      end

    end

    callback.(result_list)
  end

  def parse_doc(document, callback) do
    command_path = Path.expand(
      Path.join(
        Path.dirname(__FILE__),
        "../../cbin/markdown"
      )
    )

    command_line = bitstring_to_list("#{command_path} -s '#{document}'")

    port = Port.open({ :spawn, command_line },
      [:stream, :binary, :exit_status, :hide, :use_stdio, :stderr_to_stdout])

    do_cmd(port, callback)
  end

  defp do_cmd(port, callback, data_stack // "") do
    receive do
      { ^port, { :data, data } } ->
        do_cmd(port, callback, data_stack <> data)

      { ^port, { :exit_status, status } } ->
        case status do
          0 -> callback.({:ok,    data_stack})
          _ -> callback.({:error, data_stack})
        end

    end
  end

end
