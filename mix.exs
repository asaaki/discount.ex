defmodule Mix.Tasks.Compile.Discount do
  @shortdoc "Compiles discount library"
  def run(_) do
    Mix.shell.info System.cmd("make priv/markdown.so")
  end
end

defmodule Discount.Mixfile do
  use Mix.Project

  def project do
    [
      app:        :discount,
      version:    "0.3.1",
      elixir:     ">= 0.10.3",
      compilers:  [ :discount, :elixir, :app ],
      source_url: "https://github.com/asaaki/discount.ex",
      deps:       deps
    ]
  end

  def application, do: []

  defp deps, do: []

end
