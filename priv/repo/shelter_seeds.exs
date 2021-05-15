# Script for populating the database. You can run it as:
#
#     mix run priv/repo/shelter_seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fyp.Repo.insert!(%Fyp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Logger

shelter_data = [
  %{
    title: "Приют \"Друг\"",
    vk_link: "https://vk.com/priyut_drugspb",
    site_link: "http://priyut-drug.ru/"
  },
  %{
    title: "Приют \"Ржевка\"",
    vk_link: "https://vk.com/priut_rgevka",
    site_link: "http://shelter-rzhevka.com/"
  }
]

Enum.each(shelter_data, fn shelter ->
  Fyp.Shelter.create(shelter)
end)
