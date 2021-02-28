defmodule Fyp.WebScraping do
  @moduledoc """
  Scrape pets data from web cites using HTTPoison and Floki
  """
  require Logger

  def get_pets() do
    pets =
      get_pets_url
      |> get_pets_html_body
      |> Enum.map(fn body ->
        %{
          name: get_pet_name(body),
          breed: get_pet_breed(body),
          gender: get_pet_gender(body),
          birth: get_pet_birthday(body),
          height: get_pet_height(body),
          description: get_pet_description(body),
          photos: get_pet_photos(body),
        }
      end)
  end

  def get_pets_url(url \\ "http://priyut-drug.ru/take/") do
    Logger.warn("Getting data from #{url}")
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        urls =
          body
          # TODO replace with {:ok, document}
          |> Floki.parse_document!()
          |> Floki.find("table")
          # As photo is also a url, but without text
          |> Floki.find("a:fl-contains('')")
          |> Floki.attribute("href")

        have_next =
          body
          |> Floki.parse_document!()
          |> Floki.find("li[class=arrow]")
          |> Floki.find("a")
          |> Floki.attribute("href")
        case have_next do
          [] -> urls
          [next_page] -> urls ++ get_pets_url(url <> next_page)
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.warn("Page is not found. Url: #{url}")
        []
      {:ok, %HTTPoison.Error{reason: reason}} ->
        Logger.warn("Page error. Url: #{url}. Reason: #{inspect(reason)}")
    end
  end

  def get_pets_html_body(urls) do
    urls
    |> Enum.map(fn url -> HTTPoison.get("http://priyut-drug.ru" <> url) end)
    |> Enum.map(fn {_, result} -> Floki.parse_document!(result.body) end)
  end

  def get_pet_name(body) do
    body
    |> Floki.find("h1")
    |> Floki.text
  end

  def get_pet_photos(body) do
    body
    |> Floki.find("ul.clearing-thumbs, li, a.th")
    |> Floki.attribute("href")
  end

  def get_pet_breed(body) do
    body
    |> Floki.find("table")
    |> Floki.find("tr:nth-child(1)")
    |> Floki.find("td:last-child")
    |> Floki.text
  end

  def get_pet_gender(body) do
    body
    |> Floki.find("table")
    |> Floki.find("tr:nth-child(2)")
    |> Floki.find("td:last-child")
    |> Floki.text
  end

  def get_pet_birthday(body) do
    body
    |> Floki.find("table")
    |> Floki.find("tr:nth-child(3)")
    |> Floki.find("td:last-child")
    |> Floki.text
  end

  def get_pet_height(body) do
    body
    |> Floki.find("table")
    |> Floki.find("tr:nth-child(4)")
    |> Floki.find("td:last-child")
    |> Floki.text
  end

  def get_pet_description(body) do
    body
    |> Floki.find("p[class=text-justify]")
    |> Floki.find("p:last-of-type")
    |> Floki.text
  end
end
