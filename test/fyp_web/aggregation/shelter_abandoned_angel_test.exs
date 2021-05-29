defmodule ShelterAbandonedAngelTest do
  use ExUnit.Case
  import Fyp.Scraping.ShelterAbandonedAngel

  @tag :skip
  test "Correct parsing" do
    base_url = "https://bfba.ru"
    category_url = "/sobaki/"
    pets_html_body = get_pets_html_body(category_url, base_url)
    body = Enum.at(pets_html_body, 0)
    first_pet =
      %{
        name: get_pet_name(body),
        description: get_pet_description(body),
        photos: get_pet_photos(body, base_url),
        source_link: get_pet_link(body),
      }
    assert length(first_pet[:photos]) == 5
    assert first_pet[:description] == "Марта - собака, которая по неизвестным причинам оказалась подкинутой к вет. клинике. Её нашли у дверей, свернувшейся в калачик и дрожащей от холода. Благо на её пути встретились неравнодушные люди и сейчас все трудности позади! Марта живёт на передержке, где проявляет себя с самой лучшей стороны. Она очень сообразительная, симпатичная и небольшая собака. Знает некоторые команды и хорошо обучается. Она станет для вас самым лучшим другом! Если вы хотите познакомиться с ней и подарить дом, скорее пишите нам!"
    assert first_pet[:name] == "Марта"
    assert first_pet[:source_link] == "https://bfba.ru/sobaki/"
  end
end
