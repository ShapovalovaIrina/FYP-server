defmodule PetsTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Pets

  @data %{
    "name" => "Демьян",
    "breed" => "метис",
    "gender" => "мальчик",
    "birth" => "Июл 2020",
    "height" => "50 см",
    "description" => "Общительный, ласковый песик.",
    "photos" => ["/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg",
      "/media/photologue/photos/_ncHhW9vlX4.jpg",
      "/media/photologue/photos/jpMWEsPU9VI.jpg",
      "/media/photologue/photos/KHqFllxPeAk.jpg",
      "/media/photologue/photos/xoOK2tMRMOU.jpg"]
  }

  test "Pet data (with photos) insertion" do
    {:ok, _id} = Pets.create(@data)
  end

  test "Get pet list data" do
    {:ok, id} = Pets.create(@data)
    first_pet = Pets.pet_list()
    atom_data = Map.new(@data, fn {k, v} -> {String.to_atom(k), v} end)
    assert first_pet == [Map.put(atom_data, :id, id)]
  end

  test "Get pet by id" do
    {:ok, pet_id} = Pets.create(@data)
    {:ok, pet_data} = Pets.pet_by_id(pet_id)
    atom_data = Map.new(@data, fn {k, v} -> {String.to_atom(k), v} end)
    assert pet_data == Map.put(atom_data, :id, pet_id)
  end
end
