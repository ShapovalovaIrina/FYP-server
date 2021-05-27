defmodule Fyp.Scraping.ShelterPoteryashka do
  require Logger

  def get_pets_url(page_url, base_url) do
    full_url = base_url <> page_url
    Logger.warn("Getting data from #{full_url}")

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(full_url),
         {:ok, html_tree} <- Floki.parse_document(body) do
      urls =
        html_tree
        |> Floki.find("div#allEntries")
        |> Floki.find("div.eTitle")
        |> Floki.find("a")
        |> Floki.attribute("href")
        |> IO.inspect

      have_next =
        html_tree
        |> Floki.find(".pagesBlockuz2")
        |> Floki.find("b+a")
        |> Floki.attribute("href")

      case have_next do
        [] -> urls
        [next_page] -> urls ++ get_pets_url(next_page, base_url)
      end
    else
      {:error, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("HTTPoison. Page is not found. Url: #{full_url}")
        []

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTPoison. Page error. Url: #{full_url}. Reason: #{inspect(reason)}")
        []

      {:error, reason} ->
        Logger.error("Error. Url: #{full_url}. Reason: #{inspect(reason)}")
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
    |> Floki.find("div.eTitle")
    |> Floki.find("h4")
    |> Floki.text()
  end

  def get_pet_photos(body, base_url) do
    body
    |> Floki.find("td.eText")
    |> Floki.find("tr")
    |> Floki.find("td:first-child")
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> Enum.map(fn photo_url -> base_url <> photo_url end)
  end

  def get_pet_description(body) do
    body
    |> Floki.find("td.eText")
    |> Floki.find("tr")
    |> Floki.find("td:last-child")
    |> IO.inspect
    |> Floki.text(deep: false)
    |> String.trim_leading()
    |> String.trim_trailing()
    |> String.replace("\u00A0", "")
  end
end

defimpl Fyp.Scraping.Shelters, for: ShelterPoteryashka do
  import Fyp.Scraping.ShelterPoteryashka
  require Logger

  def get_pets(%ShelterPoteryashka{link: base_url}) do
    categories = [
      {"/load/1", 2}, # Dogs
      {"/load/3", 1}  # Cats
    ]

    _pets =
      Enum.each(categories, fn {category_url, type_id} ->
        get_pets_url(category_url, base_url)
        |> get_pets_html_body(base_url)
        |> Enum.map(fn body ->
          %{
            name: get_pet_name(body),
            breed: nil,
            gender: nil,
            birth: nil,
            height: nil,
            description: get_pet_description(body),
            photos: get_pet_photos(body, base_url),
            shelter_id: 4,
            type_id: type_id
          }
        end)
        |> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
      end)
  end
end
