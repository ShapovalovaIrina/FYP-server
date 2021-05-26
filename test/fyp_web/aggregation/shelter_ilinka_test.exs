defmodule ShelterIlinkaTest do
  use ExUnit.Case

  test "Correct parsing" do
    Fyp.Scraping.Shelters.get_pets(%ShelterIlinka{link: "http://domdog.ru/"})
  end
end
