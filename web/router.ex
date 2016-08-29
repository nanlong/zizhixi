defmodule Zizhixi.Router do
  use Zizhixi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Zizhixi do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/accounts", Zizhixi do
    pipe_through [:browser, :browser_session]

    get "/signup", AccountController, :signup_page
    post "/signup", AccountController, :signup

    get "/signin", AccountController, :signin_page
    post "/signin", AccountController, :signin
  end

  # Other scopes may use custom stacks.
  # scope "/api", Zizhixi do
  #   pipe_through :api
  # end
end
