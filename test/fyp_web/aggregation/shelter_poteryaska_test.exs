defmodule ShelterPoteryaskaTest do
  use ExUnit.Case
  import Fyp.Scraping.ShelterPoteryashka

  test "Correct parsing with single photo" do
    base_url = "http://poteryashka.spb.ru"
    pet =
      get_pets_html_body(["/load/1-1-0-1754"], base_url)
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
          type_id: 1
        }
      end)
      |> hd

    assert %{
             name: "Щенки \"Лунные\"",
             breed: nil,
             gender: nil,
             birth: nil,
             height: nil,
             description:
               "Два чудесных щеночка, им всего по 2,5 месяца. Детишки домашние, здоровенькие, упитанные и здоровые.\nЗвоните!",
             photos: _,
             shelter_id: 4,
             type_id: 1
           } = pet

    %{photos: photos} = pet
    assert length(photos) == 1
  end

  test "Correct parsing with multiple photos" do
    base_url = "http://poteryashka.spb.ru"
    pet =
      get_pets_html_body(["/load/3-1-0-1145"], base_url)
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
          type_id: 1
        }
      end)
      |> hd

    assert %{
             name: "Муся-Трехцветка",
             breed: nil,
             gender: nil,
             birth: nil,
             height: nil,
             description:
               "Муся-Трёхцветка - смешная круглая кошечка с золотыми глазами и спокойным нравом. У кисы очень яркий красивый окрас, она точно разбавит собой серые питерские будни и привнесёт в Вашу жизнь яркие краски и тепло. По характеру подойдёт как для взрослых, так и для семей с детьми.\nЗдорова и стерилизована.",
             photos: _,
             shelter_id: 4,
             type_id: 1
           } = pet

    %{photos: photos} = pet
    assert length(photos) == 4
  end
end
