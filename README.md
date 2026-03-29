# FacilGuide

[![Hex.pm](https://img.shields.io/hexpm/v/facilguide.svg)](https://hex.pm/packages/facilguide)

Multilingual content utilities for Elixir, built around the translation patterns used by
Facil.guide. The site publishes technology guides written specifically for seniors in five
languages: English, Spanish, French, Portuguese, and Italian. This library provides locale
management, URL routing helpers, and string lookup functions that mirror the site's architecture.

## Installation

Add `facilguide` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:facilguide, "~> 0.1.2"}
  ]
end
```

## Quick Start

Resolve a locale from a URL path prefix:

```elixir
FacilGuide.detect_locale("/es/guia/configurar-wifi")
# :es

FacilGuide.detect_locale("/guide/setup-wifi")
# :en
```

Build localized paths for a given slug across all supported languages:

```elixir
FacilGuide.localized_paths("setup-wifi")
|> Enum.each(fn {locale, path} ->
  IO.puts("#{locale}: #{path}")
end)
# en: /guide/setup-wifi
# es: /es/guia/configurar-wifi
# fr: /fr/guide/configurer-wifi
# pt: /pt/guia/configurar-wifi
# it: /it/guida/configurare-wifi
```

Check whether a locale is supported and get its display metadata:

```elixir
case FacilGuide.locale_info(:fr) do
  {:ok, %{name: name, direction: dir, flag: flag}} ->
    IO.puts("#{flag} #{name} (#{dir})")

  :error ->
    IO.puts("Locale not supported")
end
# French (ltr)
```

Generate hreflang alternate link data for SEO output:

```elixir
FacilGuide.hreflang_tags("setup-wifi")
|> Enum.map(fn %{locale: loc, url: url} ->
  ~s(<link rel="alternate" hreflang="#{loc}" href="#{url}" />)
end)
|> Enum.join("\n")
```

## Available Data

FacilGuide covers everyday technology tasks that seniors encounter most frequently. Guide
categories include smartphone basics, WiFi and internet setup, video calling, email
management, online safety, app installation, and photo sharing. Each guide is structured with
large text, step-by-step instructions, and screenshot placeholders. The five supported
languages are maintained in parallel, with translation consistency enforced by a shared
string table. The locale system handles right-to-left detection, URL prefix routing, and
hreflang tag generation for search engine optimization across all language variants.

## Links

- [Facil.guide](https://facil.guide) -- accessible tech guides for seniors in 5 languages
- [Source Code](https://github.com/arnaudleroy-studio/facilguide-elixir)

## License

MIT -- see [LICENSE](LICENSE) for details.
