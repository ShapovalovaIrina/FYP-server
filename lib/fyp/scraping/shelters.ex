defprotocol Fyp.Scraping.Shelters do
  def get_pets(shelter_link)
end

defmodule ShelterFriend do
  defstruct [:link]
end

defmodule ShelterIlinka do
  defstruct [:link]
end

defmodule ShelterPoteryashka do
  defstruct [:link]
end

defmodule ShelterAbandonedAngel do
  defstruct [:link]
end
