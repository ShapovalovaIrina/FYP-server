defmodule ShelterAbandonedAngelTest do
  use ExUnit.Case
  import Fyp.Scraping.ShelterFriend

  test "Correct parsing" do
    Fyp.Scraping.Shelters.get_pets(%ShelterAbandonedAngel{link: "https://bfba.ru/"})
  end
end
