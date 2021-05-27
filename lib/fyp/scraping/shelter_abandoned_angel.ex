defmodule Fyp.Scraping.ShelterAbandonedAngel do
  require Logger

  def get_pets_html_body(page_url, base_url) do
    full_url = base_url <> page_url
    Logger.warn("Getting data from #{full_url}")

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(full_url),
         {:ok, html_tree} <- Floki.parse_document(body) do
      pets_html_tree =
        html_tree
        |> Floki.find("div.col-xs-12")
        |> Floki.find("div.ms2_product box")

      have_next =
        html_tree
        |> Floki.find("ul.paginator")
        |> Floki.find("li[class=page-item active]+li")
        |> Floki.find("a")
        |> Floki.attribute("href")

      case have_next do
        [] -> pets_html_tree
        [next_page] -> pets_html_tree ++ get_pets_url(next_page, base_url)
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

  def get_pet_name(body) do
    body
    |> Floki.find("form.ms2_form")
    |> Floki.find("h3")
    |> Floki.text()
  end

  def get_pet_photos(body) do
    body
    |> Floki.find("div#msGallery")
    |> Floki.find("img#fotorama__img")
    |> Floki.attribute("src")
  end

  def get_pet_description(body) do
    body
    |> Floki.find("div[class=ms2_product box]>p")
    |> Floki.text(sep: "\n")
    |> String.trim_leading()
    |> String.trim_trailing()
    |> String.replace("\u00A0", "")
  end
end

defimpl Fyp.Scraping.Shelters, for: ShelterAbandonedAngel do
  import Fyp.Scraping.ShelterAbandonedAngel
  require Logger

  def get_pets(%ShelterAbandonedAngel{link: base_url}) do
    categories = [
      {"/sobaki/", 2},
      {"/koshki/kotyata/", 1},
      {"/koshki/vzroslyie/", 1},
      {"/koshki/starichki/", 1}
    ]

    _pets =
      Enum.each(categories, fn {category_url, type_id} ->
        get_pets_html_body(base_url, category_url)
        |> Enum.map(fn body ->
          %{
            name: get_pet_name(body),
            breed: nil,
            gender: nil,
            birth: nil,
            height: nil,
            description: get_pet_description(body),
            photos: get_pet_photos(body, base_url),
            shelter_id: 5,
            type_id: type_id
          }
        end)
        |> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
      end)
  end
end
