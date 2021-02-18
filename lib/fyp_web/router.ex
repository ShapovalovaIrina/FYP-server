defmodule FypWeb.Router do
  use FypWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FypWeb do
    pipe_through :api
  end
end
