defmodule UserDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Users

  @user_data %{
    name: "Username",
    email: "user@mail.com"
  }

  test "User creation" do
    {:ok, id} = Users.create(@user_data)
    {:ok, user} = Users.show(id)
    assert @user_data == Map.take(user, [:name, :email])
  end

  test "User deletion" do
    {:ok, id} = Users.create(@user_data)
    {:ok, user} = Users.show(id)
    assert @user_data == Map.take(user, [:name, :email])

    :ok = Users.delete(id)
    {:error, :not_found} = Users.show(id)
  end

  test "Delete non-existent user" do
    :not_found = Users.delete(1)
  end
end
