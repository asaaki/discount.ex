defmodule DiscountDiscountTest do
  use ExUnit.Case

  test "Discount.Discount.to_html/1 compiles Markdown to HTML" do

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

    parsed_html = Discount.Discount.to_html(markdown_doc) <> "\n"

    assert parsed_html == expected_html
  end
end
