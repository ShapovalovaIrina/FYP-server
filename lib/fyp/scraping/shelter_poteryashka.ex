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
        %{source: response.request_url, body: html_tree}
      else
        _error -> %{source: response.request_url, body: []}
      end
    end)
  end

  def get_pet_name(%{body: body} = _pet) do
    body
    |> Floki.find("div.eTitle")
    |> Floki.find("h4")
    |> Floki.text()
  end

  def get_pet_photos(%{body: body} = _pet, base_url) do
    body =
      body
      |> Floki.find("td.eText")

    case Floki.find(body, "div#msg") do
      [{_tag_name, _attributes, []}] ->
        body
        |> Floki.find("tr")
        |> Floki.find("td:first-child")
        |> Floki.find("img")
        |> Floki.attribute("src")
        |> Enum.map(fn photo_url -> base_url <> photo_url end)

      [{_tag_name, _attributes, children_nodes}] ->
        children_nodes
        |> Floki.find("a")
        |> Floki.attribute("href")
        |> Enum.map(fn photo_url -> base_url <> photo_url end)

      _ ->
        []
    end
  end

  def get_pet_description(%{body: body} = _pet) do
    body
    |> Floki.find("td.eText")
    |> Floki.find("tr")
    |> Floki.find("td:last-child")
    |> Floki.text(sep: "\n")
    |> String.trim_leading()
    |> String.trim_trailing()
    |> String.replace("\u00A0", "")
    |> String.replace(~r/(\n)+/, "\n")
  end

  def get_pet_link(%{source: link} = _pet) do
    link
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
    {:ok, shelter_id} = Fyp.Shelter.get_shelter_by_title("Центр помощи бездомным животным \"Потеряшка\"")

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
            source_link: get_pet_link(body),
            shelter_id: shelter_id,
            type_id: type_id
          }
        end)
        |> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
      end)
  end
end
