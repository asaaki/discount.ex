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
      app:         :discount,
      version:     "0.5.3",
      elixir:      "~> 0.14.3",
      compilers:   [:discount, :elixir, :app],
      deps:        deps(Mix.env),
      package:     package,
      description: "Elixir NIF for discount, a Markdown parser"
    ]
  end

  def application, do: []

  defp package do
    [
      contributors: ["Christoph Grabo"],
      license:      "MIT",
      links: [
        { "GitHub",                "https://github.com/asaaki/discount.ex" },
        { "Issues",                "https://github.com/asaaki/discount.ex/issues" },
        { "Source (Orc/discount)", "https://github.com/Orc/discount" }
      ],
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

  defp deps(:docs), do: [{ :ex_doc, github: "elixir-lang/ex_doc" }]
  defp deps(_),     do: []
end
