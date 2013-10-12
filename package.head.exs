Expm.Package.new(
  name:        "discount",
  description: "Discount.ex - Elixir wrapper for discount, a Markdown parser",
  version:     :head,

  keywords:     [
                  "markdown",
                  "discount",
                  "parser",
                  "wrapper"
                ],
  maintainers:  [
                  [
                    name: "Christoph Grabo",
                    email: "chris@dinarrr.com"
                  ]
                ],
  repositories: [
                  [ github: "asaaki/discount.ex" ]
                ],
  dependencies: [
                  { "parallel", :head }
                ])
