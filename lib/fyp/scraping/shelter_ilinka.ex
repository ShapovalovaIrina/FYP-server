defmodule Fyp.Scraping.ShelterIlinka do
  require Logger

  def get_pets_url(url) do
    Logger.warn("Getting data from #{url}")

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, html_tree} <- Floki.parse_document!(body) do
      urls =
        html_tree
        |> Floki.find(".cblock petcards, .pcard, h2")
        |> IO.inspect()
        |> Floki.attribute("href")

      have_next =
        html_tree
        |> Floki.find(".pager")
        |> Floki.find("a:[text=Далее]")
        |> IO.inspect()
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

    Logger.warn("#{inspect(pets)}")
#      |> get_pets_html_body(url)
#      |> Enum.map(fn body ->
#        %{
#          name: get_pet_name(body),
#          breed: get_pet_breed(body),
#          gender: get_pet_gender(body),
#          birth: get_pet_birthday(body),
#          height: get_pet_height(body),
#          description: get_pet_description(body),
#          photos: get_pet_photos(body, url),
#          shelter_id: 3,
#          type_id: 1
#        }
#      end)
#      |> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
  end
end
