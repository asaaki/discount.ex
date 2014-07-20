defmodule DiscountTest do
  use ExUnit.Case

  test "Discount.to_html/1 compiles a single Markdown text to HTML" do
    result_html   = File.read!("test/single_doc.md") |> Discount.to_html
    expected_html = File.read!("test/single_doc.html") |> String.strip

    assert expected_html == result_html
  end

  test "Discount.to_html/2 compiles a single Markdown text to HTML and calls function with result" do
    markdown_doc  = File.read!("test/single_doc.md")
    expected_html = File.read!("test/single_doc.html") |> String.strip

    Discount.to_html markdown_doc, &(assert expected_html == &1)
  end

  test "Discount.to_html/1 compiles a list of Markdown documents" do
    [ markdown_list, expected_list ] = get_prepared_lists

    assert expected_list == Discount.to_html(markdown_list)
  end

  test "Discount.to_html/2 compiles a list of Markdown documents and calls function with result list" do
    [ markdown_list, expected_list ] = get_prepared_lists

    Discount.to_html markdown_list, &(assert expected_list == &1)
  end


  test "Discount.to_html/2 fails if input is not a proper list or bitstring/binary" do
    assert_raise_helper_collection(&assert_raise_helper_for_to_html/1)
  end

  test "Discount.to_html_each/2 compiles a list of Markdown documents and calls function for each item" do
    [ markdown_list, expected_list ] = get_prepared_lists

    Discount.to_html_each markdown_list, fn (result_item) ->
      assert Enum.any?(expected_list, &(&1 == result_item))
    end
  end

  test "Discount.to_html_each/2 fails if input is not a proper list" do
    assert_raise_helper_collection(&assert_raise_helper_for_to_html_each/1)
  end

  test "Highly parallel testing (concurrency performance and collision check) - SIMPLE!" do
    md_text       = "## test P / 'single quotes', \"double quotes\""
    expected_html = "<h2>test P / &lsquo;single quotes&rsquo;, &ldquo;double quotes&rdquo;</h2>"
    [ markdown_list, expected_list ] = create_simple_list(100_000, md_text, expected_html)

    assert expected_list == Discount.to_html(markdown_list)
  end

  test "Highly parallel testing (concurrency performance and collision check)" do
    md_text       = "## test P / 'single quotes', \"double quotes\""
    expected_html = "<h2>test P / &lsquo;single quotes&rsquo;, &ldquo;double quotes&rdquo;</h2>"
    [ markdown_list, expected_list ] = create_list(100_000, md_text, expected_html)

    assert expected_list == Discount.to_html(markdown_list)
  end

  # test helper methods

  defp assert_raise_helper_collection(func) do
    [
      { :tuple },
      true,
      false,
      nil,
      2342,
      23.42,
      fn-> :dummy end,
      self(),
      make_ref,
      Port.open({:spawn,'echo dummy 2>&1 >/dev/null'},[])
    ] |> Enum.each(fn(e)-> func.(e) end)
  end

  defp assert_raise_helper_for_to_html(input_value) do
    assert_raise_helper(&Discount.to_html(&1), "Discount.to_html/1", input_value)
    assert_raise_helper(&Discount.to_html(&1, fn(_)-> end), "Discount.to_html/2", input_value)
  end

  defp assert_raise_helper_for_to_html_each(input_value) do
    assert_raise_helper(&Discount.to_html_each(&1, fn(_)-> end),"Discount.to_html_each/2", input_value)
  end

  defp assert_raise_helper(func, func_s, input_value) do
    assert_raise FunctionClauseError, "no function clause matching in #{func_s}", fn -> func.(input_value) end
  end

  defp get_prepared_lists do
    markdown_list = [
      "# test A",
      "## test B with 'single quotes' and \"double quotes\"",
      "```elixir\ntest C\n```",
      "```elixir\ntest \"C2\"\n```",
      "```elixir\ntest 'C3'\n```",
      "test `D`\n---",
      "> *test* __E__"
    ]

    expected_list = [
      "<h1>test A</h1>",
      "<h2>test B with &lsquo;single quotes&rsquo; and &ldquo;double quotes&rdquo;</h2>",
      "<pre><code class=\"elixir  \">test C  \n</code></pre>",
      "<pre><code class=\"elixir  \">test \"C2\"  \n</code></pre>",
      "<pre><code class=\"elixir  \">test 'C3'  \n</code></pre>",
      "<h2>test <code>D</code>  </h2>",
      "<blockquote><p><em>test</em> <strong>E</strong></p></blockquote>"
    ]

    [markdown_list, expected_list]
  end

  defp create_simple_list(itemcount, markdown, html) do
    num_list = (1 .. itemcount) |> Enum.to_list
    [
      (num_list |> Enum.map(fn(_) -> markdown end)),
      (num_list |> Enum.map(fn(_) -> html end))
    ]
  end

  defp create_list(itemcount, markdown, html) do
    num_list = (1 .. itemcount) |> Enum.to_list
    [
      Enum.map(num_list, &("#{markdown}\n*idx: #{&1}*")),
      Enum.map(num_list, &("#{html}\n\n<p><em>idx: #{&1}</em></p>"))
    ]
  end
end
