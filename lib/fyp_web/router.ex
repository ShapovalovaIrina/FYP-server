defmodule FypWeb.Router do
  use FypWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :accepts, ["json"]
    plug AuthorizationPlug
  end

  scope "/pets", FypWeb do
    pipe_through :api

    get "/", PetController, :pet_list
    get "/:id", PetController, :pet
  end

  scope "/users", FypWeb do
    pipe_through :auth

    post "/", UserController, :create_user
    get "/", UserController, :show_user
    delete "/", UserController, :delete_user

    post "/favourite/:pet_id", FavouriteController, :add_favourite_pet
    delete "/favourite/:pet_id", FavouriteController, :remove_favourite_pet
  end

  scope "/auth", FypWeb do
    pipe_through :auth
    get "/", TestController, :test_response
  end
end
