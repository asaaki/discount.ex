defmodule Discount.Markdown do
  @on_load { :init, 0 }

  def init do
    path = :filename.join(:code.priv_dir(:discount), 'markdown')
    :ok  = :erlang.load_nif(path, 1)
  end

  def nif_to_html(_) do
    exit(:nif_library_not_loaded)
  end

  def parse_doc_list(documents) do
    Enum.map documents, fn(document) -> parse_doc(document) end
  end

  def parse_doc_list(documents, callback) do
    callback.(parse_doc_list(documents))
  end

  def parse_doc_list_each(documents, callback) do
    Enum.map documents, fn(document) ->
      parse_doc(document, callback)
    end
  end

  def parse_doc(document) do
    nif_to_html(document)
  end

  def parse_doc(document, callback) do
    callback.([{ :ok, nif_to_html(document) }])
  end

end
