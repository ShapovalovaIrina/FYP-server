defmodule PetsTest do
  use ExUnit.Case
  use Fyp.DataCase, async: true

  alias Fyp.Pets

  @data %{
    birth: "Июл 2020",
    breed: "метис",
    description: "Общительный, ласковый песик.",
    gender: "мальчик",
    height: "50 см",
    name: "Демьян",
    photos: ["/media/photologue/photos/VTzN9xCbeWg.jpg",
      "/media/photologue/photos/mQDrbrDU_z0.jpg",
      "/media/photologue/photos/_ncHhW9vlX4.jpg",
      "/media/photologue/photos/jpMWEsPU9VI.jpg",
      "/media/photologue/photos/KHqFllxPeAk.jpg",
      "/media/photologue/photos/xoOK2tMRMOU.jpg"]
  }

  test "Pet data (with photos) insertion" do
    result = Pets.create(@data)
    assert result == :ok
  end
end
