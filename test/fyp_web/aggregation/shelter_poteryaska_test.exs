defmodule ShelterPoteryaskaTest do
  use ExUnit.Case
  import Fyp.Scraping.ShelterPoteryashka

  test "Correct parsing" do
    Fyp.Scraping.Shelters.get_pets(%ShelterPoteryashka{link: "http://poteryashka.spb.ru/"})
  end
end
