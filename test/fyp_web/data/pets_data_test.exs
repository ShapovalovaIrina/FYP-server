defmodule PetsTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Pets
  alias Fyp.Favourites
  alias Fyp.Users

  @data %{
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

  test "Pet data (with photos) insertion" do
    {:ok, _id} = Pets.create(@data)
  end

  test "Get pet list data" do
    {:ok, id} = Pets.create(@data)
    first_pet =
      Pets.pet_list()
      |> Enum.map(fn struct -> Pets.map_from_pet_struct(struct) end)
    expected_pet =
      @data
      |> Map.merge(%{id: id, shelter: @shelter_data, type: @type_data})
      |> Map.drop([:shelter_id, :type_id])
    assert first_pet == [expected_pet]
  end

  test "Get pet by id" do
    {:ok, pet_id} = Pets.create(@data)
    {:ok, pet_data} = Pets.pet_by_id(pet_id)
    pet_data = Pets.map_from_pet_struct(pet_data)
    expected_pet =
      @data
      |> Map.merge(%{id: pet_id, shelter: @shelter_data, type: @type_data})
      |> Map.drop([:shelter_id, :type_id])
    assert pet_data == expected_pet
  end

  test "Duplicate pet" do
    {:ok, pet_id_1} = Pets.create(@data)
    {:ok, pet_id_2} = Pets.create(@data)
    list = Pets.pet_list()
    assert pet_id_1 == pet_id_2
    assert 1 == length(list)
  end

  test "Update favorite pet (make sure favourite relation not deleted on pet update)" do
    {:ok, pet_id_1} = Pets.create(@data)
    {:ok, user_id} = Users.create(@user_data)

    {:ok, _new_user} = Favourites.add_favourite_for_user(user_id, pet_id_1)

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id_1)
    assert length(favourite_pets) == 1
    assert length(liked_by_users) == 1

    {:ok, pet_id_2} = Pets.create(@data)
    assert pet_id_1 == pet_id_2

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id_2)
    assert length(favourite_pets) == 1
    assert length(liked_by_users) == 1
  end

  test "Delete pet" do
    {:ok, pet_id} = Pets.create(@data)
    {:ok, _pet_data} = Pets.pet_by_id(pet_id)

    :ok = Pets.delete_pet(pet_id)
    {:error, :not_found} = Pets.pet_by_id(pet_id)
  end

  test "Pet without shelter id" do
    pet =  %{
      name: "Демьян",
      description: "Общительный, ласковый песик.",
      type_id: 2
    }
    :error = Pets.create(pet)

    list = Pets.pet_list()
    assert length(list) == 0
  end
end
