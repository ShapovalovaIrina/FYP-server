defmodule FavouriteDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Favourites
  alias Fyp.Pets
  alias Fyp.Users

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
      "/media/photologue/photos/xoOK2tMRMOU.jpg"
    ],
    source_link: "http://priyut-drug.ru/take/1/416/",
    shelter_id: 1,
    type_id: 2
  }

  @shelter_data %{
    id: 1,
    title: "Приют \"Друг\"",
    vk_link: "https://vk.com/priyut_drugspb",
    site_link: "http://priyut-drug.ru/"
  }

  @type_data %{
    type: "Собака"
  }

  @user_data %{
    id: "ty6kse",
    email: "user@mail.com"
  }

  test "Add pet to favourite" do
    {:ok, pet_id} = Pets.create(@pet_data)
    {:ok, user_id} = Users.create(@user_data)

    {:ok, _new_user} = Favourites.add_favourite_for_user(user_id, pet_id)

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)

    assert length(favourite_pets) == 1
    assert length(liked_by_users) == 1

    pet =
      hd(favourite_pets)
      |> Fyp.Repo.preload(:photos)
      |> Fyp.Repo.preload(:shelter)
      |> Fyp.Repo.preload(:type)
      |> Pets.map_from_pet_struct()

    expected_pet =
      @pet_data
      |> Map.merge(%{id: pet_id, shelter: @shelter_data, type: @type_data})
      |> Map.drop([:shelter_id, :type_id])

    assert expected_pet == pet
    assert @user_data == Users.map_from_struct(hd(liked_by_users))
  end

  test "Add favourite to non-existent user" do
    {:ok, pet_id} = Pets.create(@pet_data)
    user_id = "1000"

    {:error, :not_found} = Favourites.add_favourite_for_user(user_id, pet_id)

    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)

    assert length(liked_by_users) == 0
  end

  test "Add non-existent pet to favourite" do
    pet_id = Ecto.UUID.generate()
    {:ok, user_id} = Users.create(@user_data)

    {:error, :not_found} = Favourites.add_favourite_for_user(user_id, pet_id)

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)

    assert length(favourite_pets) == 0
  end

  test "Delete from favourite" do
    {:ok, pet_id} = Pets.create(@pet_data)
    {:ok, user_id} = Users.create(@user_data)

    {:ok, _new_user} = Favourites.add_favourite_for_user(user_id, pet_id)

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)

    assert length(favourite_pets) == 1
    assert length(liked_by_users) == 1

    {:ok, _new_user} = Favourites.delete_favourite_from_user(user_id, pet_id)

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)

    assert length(favourite_pets) == 0
    assert length(liked_by_users) == 0
  end

  test "Delete favourite from non-existent user" do
    {:ok, pet_id} = Pets.create(@pet_data)
    user_id = "1000"

    {:error, :not_found} = Favourites.delete_favourite_from_user(user_id, pet_id)
  end

  test "Delete non-existent pet from favourite" do
    pet_id = Ecto.UUID.generate()
    {:ok, user_id} = Users.create(@user_data)

    {:error, :not_found} = Favourites.delete_favourite_from_user(user_id, pet_id)
  end

  test "Delete pet from empty list (user and pets are not bind)" do
    {:ok, pet_id} = Pets.create(@pet_data)
    {:ok, user_id} = Users.create(@user_data)

    {:error, :no_related_pets} = Favourites.delete_favourite_from_user(user_id, pet_id)
  end
end
