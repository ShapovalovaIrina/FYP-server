defmodule PetsTest do
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
    shelter_id: 1
  }

  @shelter_data %{
    title: "Shelter Friend",
    vk_link: "",
    site_link: ""
  }

  test "Pet data (with photos) insertion" do
    str_data = Map.new(@data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, _id} = Pets.create(str_data)
  end

  test "Get pet list data" do
    str_data = Map.new(@data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, id} = Pets.create(str_data)
    first_pet =
      Pets.pet_list()
      |> Enum.map(fn struct -> Pets.map_from_pet_struct(struct) end)
    expected_pet =
      @data
      |> Map.merge(%{id: id, shelter: @shelter_data})
      |> Map.delete(:shelter_id)
    assert first_pet == [expected_pet]
  end

  test "Get pet by id" do
    str_data = Map.new(@data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, pet_id} = Pets.create(str_data)
    {:ok, pet_data} = Pets.pet_by_id(pet_id)
    pet_data = Pets.map_from_pet_struct(pet_data)
    expected_pet =
      @data
      |> Map.merge(%{id: pet_id, shelter: @shelter_data})
      |> Map.delete(:shelter_id)
    assert pet_data == expected_pet
  end

  test "Duplicate pet" do
    str_data = Map.new(@data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, pet_id_1} = Pets.create(str_data)
    {:ok, pet_id_2} = Pets.create(str_data)
    list = Pets.pet_list()
    assert pet_id_1 == pet_id_2
    assert 1 == length(list)
  end
end
