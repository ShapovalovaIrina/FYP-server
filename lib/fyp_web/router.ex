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

  scope "/users", FypWeb do
    pipe_through :api

    post "/", UserController, :create_user
    get "/:id", UserController, :show_user
    delete "/:id", UserController, :delete_user

    post "/:id/favourite/:pet_id", FavouriteController, :add_favourite_pet
    delete "/:id/favourite/:pet_id", FavouriteController, :remove_favourite_pet
  end
end
