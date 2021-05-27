defmodule ShelterIlinkaTest do
  use ExUnit.Case
  import Fyp.Scraping.ShelterIlinka

  test "Correct parsing" do
    pet =
      get_pets_html_body(["http://domdog.ru/dogs/352-nika.html"])
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
      |> hd

    assert %{
             name: "Ника",
             breed: nil,
             gender: nil,
             birth: "д.р. май 2013 г.",
             height: nil,
             description:
               "Ника - Нескучная Леди. Настоящая аристократка, полная изящества и достоинства. Предательство человека, которое ей пришлось пережить, не сломило ее духа и не лишило горделивой осанки. Стойко приняла она тяготы приютской жизни. Осталась нежной и отзывчивой к людям. Ненавязчива, интеллигентна, любит поиграть. Отлично ходит на поводке. Знает двухразовый выгул. Дружелюбна к детям.\nНика здорова, привита, стерилизована. В холке 57 см\nНаша почта info@domdog.ru\nНаши тлф.\n+7(931)257-40-30 Алена\n+7(906)276-37-01 София",
             photos: _,
             shelter_id: 3,
             type_id: 1
           } = pet

    %{photos: photos} = pet
    assert length(photos) == 5
  end
end
