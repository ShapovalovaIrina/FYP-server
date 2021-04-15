defmodule FypWeb.ApiSpec do
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, SecurityScheme}
  alias FypWeb.Router
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      info: %Info{
        title: "Find your pet app",
        description: "API for \"Find your pet\" app server.",
        version: "1.0"
      },
      # Populate the paths from a phoenix router
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{"authorization" => %SecurityScheme{
          type: "http", scheme: "bearer", bearerFormat: "JWT"}
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules() # Discover request/response schemas from path specs
  end
end
