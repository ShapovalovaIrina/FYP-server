defmodule PetPaginationDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Pets

  @data %{
    name: "Демьян",
    description: "Общительный, ласковый песик.",
    photos: [
      "/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg",
      "/media/photologue/photos/xoOK2tMRMOU.jpg"],
    shelter_id: 1,
    type_id: 2
  }

  test "Paginate query" do
    {:ok, _} = Pets.create(@data)                  # type_id: 2, shelter_id: 1
    new_pet = Map.replace(@data, :type_id, 1)      # type_id: 1, shelter_id: 1
    {:ok, _} = Pets.create(new_pet)
    new_pet = Map.replace(new_pet, :shelter_id, 2) # type_id: 1, shelter_id: 2
    {:ok, _} = Pets.create(new_pet)
    new_pet = Map.replace(new_pet, :type_id, 2)    # type_id: 2, shelter_id: 2
    {:ok, _} = Pets.create(new_pet)

    %{entries: pets, metadata: metadata} = Pets.pet_list_pagination([], [], 3)  # request first 3 entries
    assert length(pets) == 3
    assert {2, 1} == {Enum.at(pets, 0).type_id, Enum.at(pets, 0).shelter_id}
    assert {1, 1} == {Enum.at(pets, 1).type_id, Enum.at(pets, 1).shelter_id}
    assert {1, 2} == {Enum.at(pets, 2).type_id, Enum.at(pets, 2).shelter_id}
    assert metadata.after != nil
    assert metadata.before == nil


    %{entries: pets, metadata: metadata} = Pets.pet_list_pagination([], [], 3, metadata.after, :after)  # request for last entity
    assert length(pets) == 1
    assert {2, 2} == {Enum.at(pets, 0).type_id, Enum.at(pets, 0).shelter_id}
    assert metadata.after == nil
    assert metadata.before != nil

    %{entries: pets, metadata: metadata} = Pets.pet_list_pagination([], [], 3, metadata.before, :before)  # request first 3 entries (before cursor)
    assert length(pets) == 3
    assert {2, 1} == {Enum.at(pets, 2).type_id, Enum.at(pets, 2).shelter_id}
    assert {1, 1} == {Enum.at(pets, 1).type_id, Enum.at(pets, 1).shelter_id}
    assert {1, 2} == {Enum.at(pets, 0).type_id, Enum.at(pets, 0).shelter_id}
    assert metadata.after != nil
    assert metadata.before == nil
  end
end
