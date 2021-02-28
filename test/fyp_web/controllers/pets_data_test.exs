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
    photos: ["/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg",
      "/media/photologue/photos/_ncHhW9vlX4.jpg",
      "/media/photologue/photos/jpMWEsPU9VI.jpg",
      "/media/photologue/photos/KHqFllxPeAk.jpg",
      "/media/photologue/photos/xoOK2tMRMOU.jpg"]
  }

  test "Pet data (with photos) insertion" do
    str_data = Map.new(@data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, _id} = Pets.create(str_data)
  end

  test "Get pet list data" do
    str_data = Map.new(@data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, id} = Pets.create(str_data)
    first_pet = Pets.pet_list()
    assert first_pet == [Map.put(@data, :id, id)]
  end

  test "Get pet by id" do
    str_data = Map.new(@data, fn {k, v} -> {Atom.to_string(k), v} end)
    {:ok, pet_id} = Pets.create(str_data)
    {:ok, pet_data} = Pets.pet_by_id(pet_id)
    assert pet_data == Map.put(@data, :id, pet_id)
  end
end
