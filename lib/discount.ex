defmodule Discount do

  def to_html(input_data, callback) when is_list(input_data) do
    Discount.Markdown.parse_doc_list input_data, callback
  end

  def to_html(input_data, callback) when is_bitstring(input_data) do
    Discount.Markdown.parse_doc input_data, callback
  end

  def to_html(input_data) when is_list(input_data) do
    Discount.Markdown.parse_doc_list input_data
  end

  def to_html(input_data) when is_bitstring(input_data) do
    Discount.Markdown.parse_doc(input_data)
  end

end
