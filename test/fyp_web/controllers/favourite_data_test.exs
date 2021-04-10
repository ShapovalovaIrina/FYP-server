defmodule FavouriteDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Favourites
  alias Fyp.Pets
  alias Fyp.Users

  require Logger

  @pet_data %{
    name: "Демьян",
    breed: "метис",
    gender: "мальчик",
    birth: "Июл 2020",
    height: "50 см",
    description: "Общительный, ласковый песик.",
    photos: [
      "/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg",
      "/media/photologue/photos/xoOK2tMRMOU.jpg"],
    shelter_id: 1
  }

  @shelter_data %{
    title: "Shelter Friend",
    vk_link: "",
    site_link: ""
  }

  @user_data %{
    name: "Username",
    email: "user@mail.com"
  }

  test "Add pet to favourite" do
    str_data = Map.new(@pet_data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, pet_id} = Pets.create(str_data)
    {:ok, user_id} = Users.create(@user_data)

    {:ok, _} = Favourites.add_favourite_for_user(user_id, pet_id)

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)

    assert length(favourite_pets) == 1
    assert length(liked_by_users) == 1

    pet =
      hd(favourite_pets)
      |> Fyp.Repo.preload(:photos)
      |> Fyp.Repo.preload(:shelter)
      |> Pets.map_from_pet_struct()
    expected_pet =
      @pet_data
      |> Map.merge(%{id: pet_id, shelter: @shelter_data})
      |> Map.delete(:shelter_id)
    assert expected_pet == pet
    assert @user_data == Users.map_from_struct(hd(liked_by_users))
  end
end
