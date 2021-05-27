defmodule ShelterFriendTest do
  use ExUnit.Case
  import Fyp.Scraping.ShelterFriend

  @tag :skip
  test "Correct parsing" do
    base_url = "http://priyut-drug.ru"
    pet_url = ["/take/1/57/"]

    pet =
      get_pets_html_body(pet_url, base_url)
      |> Enum.map(fn body ->
        %{
          name: get_pet_name(body),
          breed: get_pet_breed(body),
          gender: get_pet_gender(body),
          birth: get_pet_birthday(body),
          height: get_pet_height(body),
          description: get_pet_description(body),
          photos: get_pet_photos(body, base_url),
          shelter_id: 0,
          type_id: 1
        }
      end)
      |> hd

    assert %{
             name: "Фокс",
             breed: "метис",
             gender: "мальчик",
             birth: "Июл 2012",
             height: "57 см",
             description:
               "Активный, беззлобный, веселый мальчик. Хорошо уживается с другими собаками по вольеру. Приучен к поводку. Не боится людей, не делает разницы между мужчинами и женщинами. Любит погавкать и похулиганить с незнакомыми людьми. Обожает воду, сам заходит в пруд и плавает."
           } = pet
    %{photos: photos} = pet
    assert length(photos) == 6
  end
end
