defmodule Discount.Markdown do

  def parse_doc_list(documents, callback, cmd_opts // []) do
    result_list = documents |> Parallel.map fn(document) ->
      current = self

      parse_doc document, fn(result) ->
        current <- {:parsed, result}
      end, cmd_opts

      receive do
        {:parsed, [result]} -> result
        _                   -> false
      end

    end

    callback.(result_list)
  end

  def parse_doc(document, callback, cmd_opts // []) do
    safe_doc = (document
      |> term_to_binary
      |> binary_to_term([:safe])
      |> String.replace("'","\'")
      |> String.replace("\"","\"")
      |> String.replace("`","\`")
    )

    { shm_available, _ } = File.stat("/dev/shm")
    temp_dir_path        = if shm_available == :ok, do: "/dev/shm", else: "/var/tmp"
    nanosecondized_md5   = System.cmd("echo `date +%s_%N` | md5sum") |> String.replace(%r/[ \-\n]/, "")
    md_path              = "#{temp_dir_path}/#{nanosecondized_md5}.md"

    case File.write(md_path, safe_doc) do
      :ok -> prepare_cmd(md_path, callback, cmd_opts)
      _   -> callback.([{ :error, "COULD NOT CREATE TEMPORARY FILE `#{md_path}`!" }])
    end

  end

  defp prepare_cmd(md_path, callback, cmd_opts) do
    command_path = Path.expand(
      Path.join(
        Path.dirname(__FILE__),
        "../../cbin/markdown"
      )
    )
    command_options = cmd_opts |> Enum.join(" ")
    command_line    = bitstring_to_list("#{command_path} #{md_path} #{command_options}")
    port_args       = [ :stream, :binary, :exit_status, :hide, :use_stdio, :stderr_to_stdout ]
    port            = Port.open({ :spawn, command_line }, port_args)
    do_cmd(port, md_path, callback)

  end

  defp do_cmd(port, md_path, callback, data_stack // "") do
    receive do
      { ^port, { :data, data } } ->
        do_cmd(port, md_path, callback, data_stack <> data)

      { ^port, { :exit_status, status } } ->
        File.rm_rf md_path
        case status do
          0 -> callback.([{ :ok,    data_stack }])
          _ -> callback.([{ :error, data_stack }])
        end

    end
  end

end
