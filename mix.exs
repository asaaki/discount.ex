Code.ensure_loaded?(Hex) and Hex.start

defmodule Mix.Tasks.Compile.Discount do
  @shortdoc "Compiles discount library"
  def run(_) do
    if Mix.shell.cmd("make priv/markdown.so") != 0 do
      raise Mix.Error, message: "could not run `make priv/markdown.so`. Do you have make and gcc installed?"
    end
  end
end

defmodule Discount.Mixfile do
  use Mix.Project

  def project do
    [
      app:          :discount,
      version:      "0.6.1",
      elixir:       "~> 1.0",
      compilers:    [:discount, :elixir, :app],
      deps:         deps(Mix.env),
      package:      package,
      description:  "Elixir NIF for discount, a Markdown parser",
      name:         "discount",
      source_url:   "https://github.com/asaaki/discount.ex",
      homepage_url: "http://hexdocs.pm/discount",
      docs:         [readme: true, main: "README"]
    ]
  end

  def application, do: []

  defp package do
    [
      contributors: ["Christoph Grabo"],
      licenses:     ["MIT"],
      links: %{
        "GitHub" => "https://github.com/asaaki/discount.ex",
        "Issues" => "https://github.com/asaaki/discount.ex/issues",
        "Docs"   => "http://hexdocs.pm/discount/"
      },
      files: [
        "lib",
        "src",
        "discount_src",
        "priv",
        "Makefile",
        "mix.exs",
        "README.md",
        "LICENSE"
      ]
    ]
  end

  defp deps(:dev) do
    [
      { :ex_doc,  "~> 0.6" },
      { :earmark, "~> 0.1" }
    ]
  end
  defp deps(_),     do: []
end
