# Script for populating the database. You can run it as:
#
#     mix run priv/repo/pet_seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fyp.Repo.insert!(%Fyp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

data =
[
  %{
    birth: "Июл 2020",
    breed: "метис",
    description: "Общительный, ласковый песик.",
    gender: "мальчик",
    height: "50 см",
    name: "Демьян",
    photos: [
      "https://priyut-drug.ru/media/photologue/photos/cache/VTzN9xCbeWg_thumbnail.jpg",
      "https://priyut-drug.ru/media/photologue/photos/cache/jpMWEsPU9VI_thumbnail.jpg"
    ],
    shelter_id: 1,
    pet_type_id: 2
  },
  %{
    birth: "Дек 2019",
    breed: "Метис легавой",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Урал",
    photos: ["https://priyut-drug.ru/media/photologue/photos/cache/1917dMtps7U_thumbnail.jpg"],
    shelter_id: 1,
    pet_type_id: 2
  },
  %{
    birth: "Дек 2019",
    breed: "Метис легавой",
    description: "Некрупная милая собачка.",
    gender: "девочка",
    height: "50 см",
    name: "Умчи",
    photos: ["https://priyut-drug.ru/media/photologue/photos/cache/5N6fs4FRR7E_thumbnail.jpg"],
    shelter_id: 1,
    pet_type_id: 2
  },
  %{
    birth: "Дек 2019",
    breed: "метис",
    description: "Осторожный ласковый пес",
    gender: "мальчик",
    height: "65 см",
    name: "Джамп",
    photos: ["https://priyut-drug.ru/media/photologue/photos/cache/-WHTFWuOjsU_thumbnail.jpg"],
    shelter_id: 1,
    pet_type_id: 2
  },
  %{
    birth: "Сен 2019",
    breed: "метис",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Даго",
    photos: ["https://priyut-drug.ru/media/photologue/photos/cache/s-hljyLIWXA_thumbnail.jpg"],
    shelter_id: 1,
    pet_type_id: 2
  },
  %{
    birth: "Сен 2019",
    breed: "метис",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Дайер",
    photos: ["https://priyut-drug.ru/media/photologue/photos/cache/v5k2LSCDU-o_thumbnail.jpg"],
    shelter_id: 1,
    pet_type_id: 2
  }
]

data
|> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
