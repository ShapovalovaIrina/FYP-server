defprotocol Fyp.Scraping.Shelters do
  def get_pets(shelter_link)
end

defmodule ShelterFriend do
  defstruct [:link]
end