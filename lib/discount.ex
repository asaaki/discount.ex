defmodule Discount do
  @moduledoc """
    Compiles Markdown formatted text into HTML
  """

  @doc """
    Compiles a list of Markdown documents and calls function for each item
  """
  def to_html_each(input, callback) when is_list(input) do
    Discount.Markdown.parse_doc_list_each input, callback
  end

  @doc """
    Compiles one or more (list) Markdown documents to HTML and calls function with result
  """
  def to_html(input, callback) when is_list(input) do
    Discount.Markdown.parse_doc_list input, callback
  end

  def to_html(input, callback) when is_bitstring(input) do
    Discount.Markdown.parse_doc input, callback
  end

  @doc """
    Compiles one or more (list) Markdown documents to HTML and returns result
  """
  def to_html(input) when is_list(input) do
    Discount.Markdown.parse_doc_list input
  end

  def to_html(input) when is_bitstring(input) do
    Discount.Markdown.parse_doc(input)
  end
end
