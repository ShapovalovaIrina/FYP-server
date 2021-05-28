defmodule Fyp.Scraping.ShelterRzhevka do
  alias FypWeb.VKApi
  require Logger

  @photos_get "photos.get"
  @access_token "38e8a2b538e8a2b538e8a2b55e3890a7c8338e838e8a2b558580213679eca852175efe3"
  @v "5.77"

  def get_pets_items(owner_id, album_id) do
    params = [params: [
      owner_id: owner_id,
      album_id: album_id,
      access_token: @access_token,
      v: @v
    ]]

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- VKApi.get(@photos_get, [], params),
         {:ok, response} <- Jason.decode(body) do
      response["response"]["items"] # All items (photos) from album
    else
      {:error, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("HTTPoison. Page is not found")
        []

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTPoison. Page error. Reason: #{inspect(reason)}")
        []

      {:error, %Jason.DecodeError{} = reason} ->
        Logger.error("Jason decode error. Reason: #{inspect(reason)}")
        []
    end
  end

  def get_pet_name(%{"text" => text} = _pet_json) do
    String.split(text, "\n", parts: 2)
    |> Enum.at(0)
  end

  def get_pet_photos(%{"sizes" => sizes} = _pet_json) do
    Enum.reduce(sizes, [], fn size, acc ->
      if size["type"] == "x", do: [size["url"] | acc], else: acc
    end)
  end

  def get_pet_description(%{"text" => text} = _pet_json) do
    text
  end
end

defimpl Fyp.Scraping.Shelters, for: ShelterRzhevka do
  import Fyp.Scraping.ShelterRzhevka
  require Logger

  def get_pets(%ShelterRzhevka{owner_id: owner_id}) do
    albums = [
      {125208433, 1}, # Cats
      {271095019, 2}, # Puppies
      {183094475, 2}  # Dogs
    ]

    _pets =
      Enum.each(albums, fn {album_id, type_id} ->
        get_pets_items(owner_id, album_id)
        |> Enum.map(fn pet_item ->
          %{
            name: get_pet_name(pet_item),
            breed: nil,
            gender: nil,
            birth: nil,
            height: nil,
            description: get_pet_description(pet_item),
            photos: get_pet_photos(pet_item),
            shelter_id: 2,
            type_id: type_id
          }
        end)
        |> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
      end)
  end
end
