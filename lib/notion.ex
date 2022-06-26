defmodule Notion do
  @moduledoc """
  Documentation for `Notion`.
  """

  use HTTPoison.Base

  @default_base_url "https://api.notion.com/v1"
  @default_api_version "2022-02-22"

  def process_url(url) do
    @default_base_url <> url
  end

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end

  def process_request_headers(headers) do
    headers ++
      [
        {"Authorization", "Bearer " <> Application.fetch_env!(:notion, :api_key)},
        {"Content-type", "application/json"},
        {"Notion-Version", @default_api_version}
      ]
  end

  @doc """
  Search a page

  Returns `{:ok, %{}}`.

  ## Examples

      iex> Notion.search(%{
        filter: %{ value: "database", property: "object" }
      })

      {:ok, %{}}
  """

  def search(params) do
    case Notion.post("/search", params) do
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, body}
      res -> res
    end
  end

  @doc """
  Insert a page

  Returns `{:ok, %{}}`.

  ## Examples

      iex> Notion.add_page(%{
        parent: %{ database_id: "8168045a713e4d0487eebba4095d6994" },
        properties: %{
          Email: %{
            type: "title",
            "title": [%{ type: "text", text: %{ content: "test@frefre.com" } }]
          }
        }
      })

      {:ok, %{}}
  """
  def add_page(params) do
    case Notion.post("/pages", params) do
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, body}
      res -> res
    end
  end
end
