defmodule DiscountTest do
  use ExUnit.Case

  test "Discount.to_html/2 compiles a single Markdown text to HTML" do

    markdown_doc = """
# First-level header

Some normal paragraph text here.

* This
* Is A
* List

## Code snippet

``` elixir
defmodule DummyModule do
  def dummy do
    true
  end
end
```

----

The *final* words __are written__ here.
    """

    expected_html = """
<h1>First-level header</h1>

<p>Some normal paragraph text here.</p>

<ul>
<li>This</li>
<li>Is A</li>
<li>List</li>
</ul>


<h2>Code snippet</h2>

<pre><code class="elixir">defmodule DummyModule do
def dummy do
true
end
end
</code></pre>

<hr />

<p>The <em>final</em> words <strong>are written</strong> here.</p>
    """

    callback_test = fn([{ status, parsed_html }]) ->
      assert status        == :ok
      assert expected_html == parsed_html
    end

    Discount.to_html markdown_doc, callback_test
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
      {:ok, "<h1>test A</h1>\n"},
      {:ok, "<h2>test B with &lsquo;single quotes&rsquo; and &ldquo;double quotes&rdquo;</h2>\n"},
      {:ok, "<pre><code class=\"elixir\">test C\n</code></pre>\n"},
      {:ok, "<pre><code class=\"elixir\">test \"C2\"\n</code></pre>\n"},
      {:ok, "<pre><code class=\"elixir\">test 'C3'\n</code></pre>\n"},
      {:ok, "<h2>test <code>D</code></h2>\n"},
      {:ok, "<blockquote><p><em>test</em> <strong>E</strong></p></blockquote>\n"}
    ]

    callback_test = fn(parsed_list) ->
      assert expected_list == parsed_list
    end

    Discount.to_html markdown_list, callback_test
  end

  test "Highly parallel testing (concurrency performance and collision check)" do
    md_text       = "## test B with 'single quotes' and \"double quotes\""
    expected_html = "<h2>test B with &lsquo;single quotes&rsquo; and &ldquo;double quotes&rdquo;</h2>"
    [ markdown_list, expected_list ] = create_list(500, md_text, expected_html)

    callback_test = fn(parsed_list) ->
      assert expected_list == Enum.sort(parsed_list)
    end

    Discount.to_html markdown_list, callback_test
  end

  defp create_list(itemcount, markdown, html) do
    num_list = Enum.to_list(1 .. itemcount)
    [
      ( num_list
        |> Parallel.map(fn(idx) -> "#{markdown}\n*idx: #{idx}*" end)
        |> Enum.sort
      ),
      ( num_list
        |> Parallel.map(fn(idx) -> { :ok, "#{html}\n\n<p><em>idx: #{idx}</em></p>\n" } end)
        |> Enum.sort
      )
    ]
  end

end
