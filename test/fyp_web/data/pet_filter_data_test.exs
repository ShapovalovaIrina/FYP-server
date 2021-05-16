defmodule PetFilterDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Pets

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
    shelter_id: 1,
    type_id: 2
  }

  test "Create dog" do
    {:ok, _} = Pets.create(@data)

    filter_dog = ["2"]
    pets = Pets.pet_list(filter_dog, [])
    assert length(pets) == 1

    filter_cat = ["1"]
    pets = Pets.pet_list(filter_cat, [])
    assert length(pets) == 0

    filter_all_types = ["1", "2"]
    pets = Pets.pet_list(filter_all_types, [])
    assert length(pets) == 1
  end

  test "Create cat" do
    cat = Map.replace(@data, :type_id, 1)
    {:ok, _} = Pets.create(cat)

    filter_dog = ["2"]
    pets = Pets.pet_list(filter_dog, [])
    assert length(pets) == 0

    filter_cat = ["1"]
    pets = Pets.pet_list(filter_cat, [])
    assert length(pets) == 1

    filter_all_types = ["1", "2"]
    pets = Pets.pet_list(filter_all_types, [])
    assert length(pets) == 1
  end

  test "Create both types" do
    {:ok, _} = Pets.create(@data)
    cat = Map.replace(@data, :type_id, 1)
    {:ok, _} = Pets.create(cat)

    filter_dog = ["2"]
    pets = Pets.pet_list(filter_dog, [])
    assert length(pets) == 1

    filter_cat = ["1"]
    pets = Pets.pet_list(filter_cat, [])
    assert length(pets) == 1

    filter_all_types = ["1", "2"]
    pets = Pets.pet_list(filter_all_types, [])
    assert length(pets) == 2
  end

  test "Create pet with shelter id 1" do
    {:ok, _} = Pets.create(@data)

    filter_shelter = ["1"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 1

    filter_shelter = ["2"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 0

    filter_shelter = ["1", "2"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 1
  end

  test "Create pet with shelter id 2" do
    new_pet = Map.replace(@data, :shelter_id, 2)
    {:ok, _} = Pets.create(new_pet)

    filter_shelter = ["1"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 0

    filter_shelter = ["2"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 1

    filter_shelter = ["1", "2"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 1
  end

  test "Create pets with both shelters" do
    {:ok, _} = Pets.create(@data)
    new_pet = Map.replace(@data, :shelter_id, 2)
    {:ok, _} = Pets.create(new_pet)

    filter_shelter = ["1"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 1

    filter_shelter = ["2"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 1

    filter_shelter = ["1", "2"]
    pets = Pets.pet_list([], filter_shelter)
    assert length(pets) == 2
  end

  test "Combine filter" do
    {:ok, _} = Pets.create(@data) # type_id: 2, shelter_id: 1
    new_pet = Map.replace(@data, :type_id, 1) # type_id: 1, shelter_id: 1
    {:ok, _} = Pets.create(new_pet)
    new_pet = Map.replace(new_pet, :shelter_id, 2) # type_id: 1, shelter_id: 2
    {:ok, _} = Pets.create(new_pet)

    pets = Pets.pet_list([], [])
    assert length(pets) == 3

    filter_type = ["1"]
    filter_shelter = ["2"]
    pets = Pets.pet_list(filter_type, filter_shelter)
    assert length(pets) == 1
  end
end
