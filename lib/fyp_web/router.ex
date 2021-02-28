defmodule FypWeb.Router do
  use FypWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/pets", FypWeb do
    pipe_through :api

    get "/", PetController, :pet_list
    get "/:id", PetController, :pet
  end
end
