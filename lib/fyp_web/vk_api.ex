defmodule FypWeb.VKApi do
  use HTTPoison.Base

  @endpoint "https://api.vk.com/method/"

  def process_url(url) do
    @endpoint <> url
  end
end
