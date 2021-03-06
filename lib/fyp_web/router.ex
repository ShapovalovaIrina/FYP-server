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

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: FypWeb.Schema
    forward "/", Absinthe.Plug, schema: FypWeb.Schema
  end
end
