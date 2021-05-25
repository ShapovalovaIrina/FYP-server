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
      "http://priyut-drug.ru/media/photologue/photos/VTzN9xCbeWg.jpg",
      "http://priyut-drug.ru/media/photologue/photos/mQDrbrDU_z0.jpg",
      "http://priyut-drug.ru/media/photologue/photos/_ncHhW9vlX4.jpg"
    ],
    shelter_id: 1,
    type_id: 2
  },
  %{
    birth: "Дек 2019",
    breed: "Метис легавой",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Урал",
    photos: [
      "http://priyut-drug.ru/media/photologue/photos/8PiwXwuBvxc.jpg",
      "http://priyut-drug.ru/media/photologue/photos/1917dMtps7U.jpg"
    ],
    shelter_id: 1,
    type_id: 2
  },
  %{
    birth: "Дек 2019",
    breed: "Метис легавой",
    description: "Некрупная милая собачка.",
    gender: "девочка",
    height: "50 см",
    name: "Умчи",
    photos: [
      "http://priyut-drug.ru/media/photologue/photos/5uYo8q25Juc.jpg",
      "http://priyut-drug.ru/media/photologue/photos/0v5HQ86wUPk.jpg"
    ],
    shelter_id: 1,
    type_id: 2
  },
  %{
    birth: "Дек 2019",
    breed: "метис",
    description: "Осторожный ласковый пес",
    gender: "мальчик",
    height: "65 см",
    name: "Джамп",
    photos: [
      "http://priyut-drug.ru/media/photologue/photos/hXVrhCEl3-M.jpg",
      "http://priyut-drug.ru/media/photologue/photos/IbmZu-iiXOU.jpg",
      "http://priyut-drug.ru/media/photologue/photos/kpVoxCcedhw.jpg"
    ],
    shelter_id: 1,
    type_id: 2
  },
  %{
    birth: "Сен 2019",
    breed: "метис",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Даго",
    photos: [
      "http://priyut-drug.ru/media/photologue/photos/zNG0JXKtqIo.jpg",
      "http://priyut-drug.ru/media/photologue/photos/EKbAxyFiiiM.jpg"
    ],
    shelter_id: 1,
    type_id: 2
  },
  %{
    birth: "Сен 2019",
    breed: "метис",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Дайер",
    photos: [
      "http://priyut-drug.ru/media/photologue/photos/JHmlyYnLtgw.jpg",
      "http://priyut-drug.ru/media/photologue/photos/nZU4NQlVnVo.jpg",
      "http://priyut-drug.ru/media/photologue/photos/7p67VtTc3OA.jpg",
      "http://priyut-drug.ru/media/photologue/photos/v5k2LSCDU-o.jpg"
    ],
    shelter_id: 1,
    type_id: 2
  }
]

data
|> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
