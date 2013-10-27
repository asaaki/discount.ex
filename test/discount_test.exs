defmodule DiscountTest do
  use ExUnit.Case

  test "Discount.to_html/2 compiles a single Markdown text to HTML" do

    { :ok, markdown_doc }  = File.read("test/single_doc.md")
    { :ok, expected_html } = File.read("test/single_doc.html")
    # Trailing line break while reading the HTML file, so we append this to our parsed result, too
    result_html            = Discount.to_html(markdown_doc) <> "\n"

    assert expected_html == result_html
  end


  test "Discount.to_html/2 compiles a list of Markdown documents" do

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

    assert expected_list == Discount.to_html(markdown_list)
  end

  test "Highly parallel testing (concurrency performance and collision check) - SIMPLE!" do
    md_text       = "## test P / 'single quotes', \"double quotes\""
    expected_html = "<h2>test P / &lsquo;single quotes&rsquo;, &ldquo;double quotes&rdquo;</h2>"
    [ markdown_list, expected_list ] = create_simple_list(100_000, md_text, expected_html)

    assert expected_list == Discount.to_html(markdown_list)
  end

  defp create_simple_list(itemcount, markdown, html) do
    num_list = Enum.to_list(1 .. itemcount)
    [
      ( num_list |> Enum.map(fn(_) -> markdown end) ),
      ( num_list |> Enum.map(fn(_) -> html end) )
    ]
  end

  test "Highly parallel testing (concurrency performance and collision check)" do
    md_text       = "## test P / 'single quotes', \"double quotes\""
    expected_html = "<h2>test P / &lsquo;single quotes&rsquo;, &ldquo;double quotes&rdquo;</h2>"
    [ markdown_list, expected_list ] = create_list(100_000, md_text, expected_html)

    assert expected_list == Discount.to_html(markdown_list)
  end

  defp create_list(itemcount, markdown, html) do
    num_list = Enum.to_list(1 .. itemcount)
    [
      ( num_list
        |> Enum.map(fn(idx) -> "#{markdown}\n*idx: #{idx}*" end) ),
      ( num_list
        |> Enum.map(fn(idx) -> "#{html}\n\n<p><em>idx: #{idx}</em></p>" end) )
    ]
  end

end
