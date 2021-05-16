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

    filter_all = ["1", "2"]
    pets = Pets.pet_list(filter_all, [])
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

    filter_all = ["1", "2"]
    pets = Pets.pet_list(filter_all, [])
    assert length(pets) == 1
  end

  test "Create both" do
    {:ok, _} = Pets.create(@data)
    cat = Map.replace(@data, :type_id, 1)
    {:ok, _} = Pets.create(cat)

    filter_dog = ["2"]
    pets = Pets.pet_list(filter_dog, [])
    assert length(pets) == 1

    filter_cat = ["1"]
    pets = Pets.pet_list(filter_cat, [])
    assert length(pets) == 1

    filter_all = ["1", "2"]
    pets = Pets.pet_list(filter_all, [])
    assert length(pets) == 2
  end
end
