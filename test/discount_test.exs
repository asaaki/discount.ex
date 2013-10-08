defmodule DiscountTest do
  use ExUnit.Case

  test "Discount.to_html/2 compiles Markdown to HTML" do

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

    callback_test = fn({status, parsed_html}) ->
      assert status      == :ok
      assert parsed_html == expected_html
    end

    Discount.to_html markdown_doc, callback_test
  end


  test "Discount.to_html/2 compiles a list of Markdown documents to HTML" do

    markdown_list = [
      "# test A",
      "## test B",
      "```elixir\ntest C\n```",
      "test `D`\n---",
      "> *test* __E__"
    ]

    expected_list = [
      {:ok, "<h1>test A</h1>\n"},
      {:ok, "<h2>test B</h2>\n"},
      {:ok, "<pre><code class=\"elixir\">test C\n</code></pre>\n"},
      {:ok, "<h2>test <code>D</code></h2>\n"},
      {:ok, "<blockquote><p><em>test</em> <strong>E</strong></p></blockquote>\n"}
    ]

    callback_test = fn(parsed_list) ->
      assert parsed_list == expected_list
    end

    Discount.to_html markdown_list, callback_test
  end

end
