# Discount.ex

Elixir NIF of Discount, a Markdown parser/converter ((GH: Orc/discount)[https://github.com/Orc/discount]).



## Build and test

make distclean
make
mix test

iex -pa ebin

```
Discount.Discount.to_html "## markdown string"
```
