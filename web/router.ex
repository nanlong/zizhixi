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

    resources "/posts", PostController do
      post "/praise", PostController, :praise, as: :praise

      resources "/comments", PostCommentController, as: :comment, only: [:create, :show, :delete] do
        post "/praise", PostCommentController, :praise, as: :praise
      end
    end

    resources "/groups", GroupController
  end

  scope "/account", Zizhixi do
    pipe_through [:browser, :browser_session]

    get "/signup", AccountController, :signup_page
    post "/signup", AccountController, :signup

    get "/signin", AccountController, :signin_page
    post "/signin", AccountController, :signin

    get "/signout", AccountController, :signout
  end

  # Other scopes may use custom stacks.
  # scope "/api", Zizhixi do
  #   pipe_through :api
  # end
end
