defmodule Fyp.Scraping.ShelterFriend do
  require Logger

  def get_pets_url(url) do
    Logger.warn("Getting data from #{url}")
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, html_tree} <- Floki.parse_document!(body) do
      urls =
        html_tree
        |> Floki.find("table")
          # As photo is also a url, but without text
        |> Floki.find("a:fl-contains('')")
        |> Floki.attribute("href")

      have_next =
        html_tree
        |> Floki.find("li[class=arrow]")
        |> Floki.find("a")
        |> Floki.attribute("href")
      case have_next do
        [] -> urls
        [next_page] -> urls ++ get_pets_url(url <> next_page)
      end
    else
      {:error, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("HTTPoison. Page is not found. Url: #{url}")
        []
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTPoison. Page error. Url: #{url}. Reason: #{inspect(reason)}")
        []
      {:error, reason} ->
        Logger.error("Error. Url: #{url}. Reason: #{inspect(reason)}")
        []
    end
  end

  def get_pets_html_body(pets_url, base_url) do
    pets_url
    |> Enum.map(fn url -> HTTPoison.get(base_url <> url) end)
    |> Enum.map(fn {res, response} ->
      with :ok <- res,
           {:ok, html_tree} <- Floki.parse_document(response.body) do
        html_tree
      else
        _error -> []
      end
    end)
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
    |> Floki.find("p:first-of-type")
    |> Floki.text
  end
end

defimpl Fyp.Scraping.Shelters, for: ShelterFriend do
  import Fyp.Scraping.ShelterFriend

  def get_pets(%ShelterFriend{link: url}) do
    # TODO handle errors from get pets url
    _pets =
      get_pets_url(url <> "/take")
      |> get_pets_html_body(url)
      |> Enum.map(fn body ->
        %{
          name: get_pet_name(body),
          breed: get_pet_breed(body),
          gender: get_pet_gender(body),
          birth: get_pet_birthday(body),
          height: get_pet_height(body),
          description: get_pet_description(body),
          photos: get_pet_photos(body),
          shelter_id: 0,
          type_id: 1
        }
      end)
      |> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
  end
end
