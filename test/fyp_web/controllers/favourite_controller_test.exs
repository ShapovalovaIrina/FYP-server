defmodule FavouriteControllerTest do
  use ExUnit.Case
  use FypWeb.ConnCase, async: false
  use Plug.Test

  alias Fyp.Favourites
  alias Fyp.Pets

  import FypWeb.ControllerUtils
  import Utils.TestUtils

  @pet_data %{
    "name" => "Демьян",
    "breed" => "метис",
    "gender" => "мальчик",
    "birth" => "Июл 2020",
    "height" => "50 см",
    "description" => "Общительный, ласковый песик.",
    "photos" => [
      "/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg",
      "/media/photologue/photos/xoOK2tMRMOU.jpg"],
    "shelter_id" => 1,
    "type_id" => 2
  }

  @user_data %{
    "id" => "123asdrfv7",
    "name" => "Joe Jonas",
    "email" => "user@mail.com"
  }

  @shelter_data %{
    "title" => "Shelter Friend",
    "vk_link" => "",
    "site_link" => ""
  }

  @type_data %{
    "type" => "Собака"
  }

  test "Add favourite pet to user", %{conn: conn} do
    {:ok, pet_id} = Pets.create(@pet_data)
    user_id = Map.get(@user_data, "id")

    authorized(conn, "user@mail.com") do
      c = post(conn, "/users")
      assert json_response(c, 201) == successful_status()

      {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
      {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)
      assert length(favourite_pets) == 0
      assert length(liked_by_users) == 0

      c = post(conn, "/users/favourite/#{pet_id}")
      assert json_response(c, 200) == successful_status()
    end

    {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
    {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)
    assert length(favourite_pets) == 1
    assert length(liked_by_users) == 1
  end

  test "Get favourites", %{conn: conn} do
    {:ok, pet_id} = Pets.create(@pet_data)
    user_id = Map.get(@user_data, "id")

    authorized(conn, "user@mail.com") do
      c = post(conn, "/users")
      assert json_response(c, 201) == successful_status()

      {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
      {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)
      assert length(favourite_pets) == 0
      assert length(liked_by_users) == 0

      c = post(conn, "/users/favourite/#{pet_id}")
      assert json_response(c, 200) == successful_status()

      c = get(conn, "/users/favourite")
      favourite_pets = json_response(c, 200)
      expected_pet =
        @pet_data
        |> Map.merge(%{"id" => pet_id, "shelter" => @shelter_data, "type" => @type_data})
        |> Map.drop(["shelter_id", "type_id"])
      assert length(favourite_pets) == 1
      assert [expected_pet] == favourite_pets
    end
  end

  test "Delete favourite pet from user", %{conn: conn} do
    {:ok, pet_id} = Pets.create(@pet_data)
    user_id = Map.get(@user_data, "id")

    authorized(conn, "user@mail.com") do
      c = post(conn, "/users")
      assert json_response(c, 201) == successful_status()

      {:ok, _new_user} = Favourites.add_favourite_for_user(user_id, pet_id)

      {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
      {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)
      assert length(favourite_pets) == 1
      assert length(liked_by_users) == 1

      c = delete(conn, "/users/favourite/#{pet_id}")
      assert json_response(c, 200) == successful_status()

      {:ok, favourite_pets} = Favourites.get_assoc_pets(user_id)
      {:ok, liked_by_users} = Favourites.get_assoc_users(pet_id)
      assert length(favourite_pets) == 0
      assert length(liked_by_users) == 0
    end
  end
end
