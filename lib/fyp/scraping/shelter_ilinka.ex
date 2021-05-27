defmodule Fyp.Scraping.ShelterIlinka do
  require Logger

  def get_pets_url(url) do
    Logger.warn("Getting data from #{url}")

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, html_tree} <- Floki.parse_document(body) do
      urls =
        html_tree
        |> Floki.find(".cblock petcards, .pcard")
        |> Floki.find("h2")
        |> Floki.find("a")
        |> Floki.attribute("href")

      have_next =
        html_tree
        |> Floki.find(".pager")
        |> Floki.find("a:fl-contains('Далее')")
        |> Floki.attribute("href")

      case have_next do
        [] -> urls
        [next_page] -> urls ++ get_pets_url(next_page)
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

  def get_pets_html_body(pets_url) do
    pets_url
    |> Enum.map(fn url -> HTTPoison.get(url) end)
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
    |> Floki.find("div[class=petcard]:first-child")
    |> Floki.find("div.desc")
    |> Floki.find("p")
    |> Floki.find("strong")
    |> Floki.text()
    |> String.split("\u00A0", parts: 2)
    |> hd
  end

  def get_pet_photos(body) do
    body
    |> Floki.find("div.pics")
    |> Floki.find("ul.thumb")
    |> Floki.find("li")
    |> Floki.find("img")
    |> Floki.attribute("src")
  end

  def get_pet_birthday(body) do
    body
    |> Floki.find("div[class=petcard]:first-child")
    |> Floki.find("div.desc")
    |> Floki.find("p")
    |> Floki.find("strong")
    |> Floki.text()
    |> String.split("\u00A0", parts: 2)
    |> Enum.at(1)
  end

  def get_pet_description(body) do
    body
    |> Floki.find("div[class=petcard]:first-child")
    |> Floki.find("div.desc")
    |> Floki.text(sep: "\n", deep: false)
    |> String.trim_leading()
    |> String.trim_trailing()
    |> String.replace("\u00A0", "")
  end
end

defimpl Fyp.Scraping.Shelters, for: ShelterIlinka do
  import Fyp.Scraping.ShelterIlinka
  require Logger

  def get_pets(%ShelterIlinka{link: url}) do
    categories = [
      "/dogs/girls/",
      "/dogs/boys/",
      "/dogs/puppy-girls/",
      "/dogs/puppy-boys/"
    ]

    pets =
      categories
      |> Enum.reduce([], fn category, acc -> acc ++ get_pets_url(url <> category) end)
      |> get_pets_html_body
      |> Enum.map(fn body ->
        %{
          name: get_pet_name(body),
          breed: nil,
          gender: nil,
          birth: get_pet_birthday(body),
          height: nil,
          description: get_pet_description(body),
          photos: get_pet_photos(body),
          shelter_id: 3,
          type_id: 1
        }
      end)
      |> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
  end
end
