defmodule FacilGuide do
  @moduledoc """
  Multilingual content utilities for Elixir applications.

  Provides locale detection, URL routing helpers, and hreflang tag generation
  based on the translation architecture used by Facil.guide, a technology
  guide site for seniors published in five languages.

  ## Supported Locales

  | Code | Language   |
  |------|------------|
  | :en  | English    |
  | :es  | Spanish    |
  | :fr  | French     |
  | :pt  | Portuguese |
  | :it  | Italian    |

  ## Usage

      FacilGuide.detect_locale("/es/guia/configurar-wifi")
      # :es

      FacilGuide.localized_paths("setup-wifi")
      # [en: "/guide/setup-wifi", es: "/es/guia/configurar-wifi", ...]

  See [Facil.guide](https://facil.guide) for the live site.
  """

  @version "0.1.2"
  @base_url "https://facil.guide"

  @locales %{
    en: %{name: "English", native: "English", direction: :ltr, prefix: nil, guide_slug: "guide"},
    es: %{name: "Spanish", native: "Espanol", direction: :ltr, prefix: "es", guide_slug: "guia"},
    fr: %{name: "French", native: "Francais", direction: :ltr, prefix: "fr", guide_slug: "guide"},
    pt: %{name: "Portuguese", native: "Portugues", direction: :ltr, prefix: "pt", guide_slug: "guia"},
    it: %{name: "Italian", native: "Italiano", direction: :ltr, prefix: "it", guide_slug: "guida"}
  }

  @doc """
  Returns the library version.

  ## Examples

      iex> FacilGuide.version()
      "0.1.2"
  """
  @spec version() :: String.t()
  def version, do: @version

  @doc """
  Returns the base URL of the Facil.guide platform.

  ## Examples

      iex> FacilGuide.base_url()
      "https://facil.guide"
  """
  @spec base_url() :: String.t()
  def base_url, do: @base_url

  @doc """
  Returns a map of all supported locales with their metadata.

  ## Examples

      iex> locales = FacilGuide.locales()
      iex> Map.has_key?(locales, :es)
      true
      iex> locales[:fr].name
      "French"
  """
  @spec locales() :: %{atom() => map()}
  def locales, do: @locales

  @doc """
  Returns a list of supported locale atoms.

  ## Examples

      iex> codes = FacilGuide.supported_locales()
      iex> :en in codes
      true
      iex> length(codes)
      5
  """
  @spec supported_locales() :: [atom()]
  def supported_locales, do: Map.keys(@locales) |> Enum.sort()

  @doc """
  Detects the locale from a URL path by inspecting the first segment.

  Paths without a recognized locale prefix default to `:en`.

  ## Examples

      iex> FacilGuide.detect_locale("/es/guia/configurar-wifi")
      :es

      iex> FacilGuide.detect_locale("/fr/guide/configurer-wifi")
      :fr

      iex> FacilGuide.detect_locale("/guide/setup-wifi")
      :en
  """
  @spec detect_locale(String.t()) :: atom()
  def detect_locale(path) when is_binary(path) do
    segment =
      path
      |> String.trim_leading("/")
      |> String.split("/")
      |> hd()

    prefix_to_locale =
      @locales
      |> Enum.filter(fn {_k, v} -> v.prefix != nil end)
      |> Enum.map(fn {k, v} -> {v.prefix, k} end)
      |> Map.new()

    Map.get(prefix_to_locale, segment, :en)
  end

  @doc """
  Looks up metadata for a specific locale. Returns `{:ok, info}` or `:error`.

  ## Examples

      iex> {:ok, info} = FacilGuide.locale_info(:it)
      iex> info.name
      "Italian"

      iex> FacilGuide.locale_info(:de)
      :error
  """
  @spec locale_info(atom()) :: {:ok, map()} | :error
  def locale_info(locale) do
    case Map.fetch(@locales, locale) do
      {:ok, _} = result -> result
      :error -> :error
    end
  end

  @doc """
  Builds localized paths for a slug across all supported languages.

  Returns a keyword list of `{locale, path}` pairs.

  ## Examples

      iex> paths = FacilGuide.localized_paths("setup-wifi")
      iex> Keyword.get(paths, :en)
      "/guide/setup-wifi"
  """
  @spec localized_paths(String.t()) :: keyword(String.t())
  def localized_paths(slug) when is_binary(slug) do
    @locales
    |> Enum.sort_by(fn {k, _} -> k end)
    |> Enum.map(fn {locale, meta} ->
      path =
        case meta.prefix do
          nil -> "/#{meta.guide_slug}/#{slug}"
          prefix -> "/#{prefix}/#{meta.guide_slug}/#{slug}"
        end

      {locale, path}
    end)
  end

  @doc """
  Generates hreflang tag data for a given slug.

  Returns a list of maps with `:locale` and `:url` keys, suitable for
  building `<link rel="alternate">` tags.

  ## Examples

      iex> tags = FacilGuide.hreflang_tags("setup-wifi")
      iex> length(tags)
      5
      iex> hd(tags).locale
      :en
  """
  @spec hreflang_tags(String.t()) :: [%{locale: atom(), url: String.t()}]
  def hreflang_tags(slug) when is_binary(slug) do
    slug
    |> localized_paths()
    |> Enum.map(fn {locale, path} ->
      %{locale: locale, url: "#{@base_url}#{path}"}
    end)
  end

  @doc """
  Returns platform information as a map.

  ## Examples

      iex> info = FacilGuide.info()
      iex> info.languages
      5
  """
  @spec info() :: map()
  def info do
    %{
      name: "FacilGuide",
      version: @version,
      base_url: @base_url,
      languages: map_size(@locales),
      supported: supported_locales()
    }
  end
end
