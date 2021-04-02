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
      "http://priyut-drug.ru/take/media/photologue/photos/VTzN9xCbeWg.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/mQDrbrDU_z0.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/_ncHhW9vlX4.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/jpMWEsPU9VI.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/KHqFllxPeAk.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/xoOK2tMRMOU.jpg"],
    shelter: 1
  },
  %{
    birth: "Дек 2019",
    breed: "Метис легавой",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Урал",
    photos: [
      "http://priyut-drug.ru/take/media/photologue/photos/8PiwXwuBvxc.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/1917dMtps7U.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/rlFic5r_3u4.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/1HrIdFPsoPU.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/RmFRDDEzLV4.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/SZudyDA1EO8.jpg"],
    shelter: 1
  },
  %{
    birth: "Дек 2019",
    breed: "Метис легавой",
    description: "Некрупная милая собачка.",
    gender: "девочка",
    height: "50 см",
    name: "Умчи",
    photos: [
      "http://priyut-drug.ru/take/media/photologue/photos/5uYo8q25Juc.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/0v5HQ86wUPk.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/8ptLHjbqnHU.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/04aKeSo6__w.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/5N6fs4FRR7E.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/R63qgwsn_h4.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/WuQRzTWItx8.jpg"],
    shelter: 1
  },
  %{
    birth: "Дек 2019",
    breed: "метис",
    description: "Осторожный ласковый пес",
    gender: "мальчик",
    height: "65 см",
    name: "Джамп",
    photos: [
      "http://priyut-drug.ru/take/media/photologue/photos/hXVrhCEl3-M.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/IbmZu-iiXOU.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/kpVoxCcedhw.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/0TzJe3RmG3w.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/-WHTFWuOjsU.jpg"],
    shelter: 1
  },
  %{
    birth: "Сен 2019",
    breed: "метис",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Даго",
    photos: [
      "http://priyut-drug.ru/take/media/photologue/photos/2020-01-07%2015.43.00.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/zNG0JXKtqIo.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/EKbAxyFiiiM.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/ylOSddBvjXk.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/s-hljyLIWXA.jpg"],
    shelter: 1
  },
  %{
    birth: "Сен 2019",
    breed: "метис",
    description: "",
    gender: "мальчик",
    height: "60 см",
    name: "Дайер",
    photos: [
      "http://priyut-drug.ru/take/media/photologue/photos/2020-01-07%2015.37.19.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/dGPn50pQ-lU.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/HFdcYL1LU6s.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/JHmlyYnLtgw.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/nZU4NQlVnVo.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/7p67VtTc3OA.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/v5k2LSCDU-o.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/Q7Xu6Jzi_HQ.jpg",
      "http://priyut-drug.ru/take/media/photologue/photos/IYglABvqhS0.jpg"],
    shelter: 1
  }
]

data
|> Enum.each(fn pet -> Fyp.Pets.create(pet) end)
