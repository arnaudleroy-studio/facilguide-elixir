defmodule FacilGuide.MixProject do
  use Mix.Project

  def project do
    [
      app: :facilguide,
      version: "0.1.1",
      elixir: "~> 1.14",
      description: "Multilingual tech guide utilities in 5 languages.",
      package: package(),
      deps: deps(),
      docs: docs(),
      source_url: "https://github.com/arnaudleroy-studio/facilguide-elixir",
      homepage_url: "https://facil.guide"
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "Homepage" => "https://facil.guide",
        "GitHub" => "https://github.com/arnaudleroy-studio/facilguide-elixir",
        "Documentation" => "https://facil.guide/en/"
      }
    ]
  end

  defp docs do
    [
      main: "FacilGuide",
      extras: ["README.md"]
    ]
  end
end
