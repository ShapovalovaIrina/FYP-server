defmodule UserDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Users

  @user_data %{
    id: "123rgb",
    name: "Username",
    email: "user@mail.com"
  }

  test "User creation" do
    {:ok, id} = Users.create(@user_data)
    {:ok, user} = Users.show(id)
    assert @user_data == Users.map_from_struct(user)
  end

  test "User deletion" do
    {:ok, id} = Users.create(@user_data)
    {:ok, user} = Users.show(id)
    assert @user_data == Users.map_from_struct(user)

    :ok = Users.delete(id)
    {:error, :not_found} = Users.show(id)
  end

  test "Delete non-existent user" do
    :not_found = Users.delete("1")
  end
end
