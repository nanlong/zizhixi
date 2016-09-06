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

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.GuardianErrorHandler]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Zizhixi do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PageController, :index

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create

    get "/signout", SessionController, :delete

    resources "/users", UserController, param: "username", only: [:show]

    resources "/groups", GroupController do
      resources "/members", GroupMemberController, as: :member, only: [:index, :create]

      resources "/posts", GroupPostController, as: :post, only: [:new, :create]
    end

    resources "/groups_members", GroupMemberController, only: [:delete]

    resources "/groups_posts", GroupPostController, only: [:edit, :update, :delete] do
      resources "/comments", GroupCommentController, as: :comment, only: [:create, :show]
    end

    resources "/group_comments", GroupCommentController, only: [:delete]
  end

  scope "/settings", Zizhixi do
    pipe_through [:browser, :browser_session, :require_login]

    get "/:view", UserController, :edit
    resources "/:view", UserController, only: [:update], singleton: true
  end
  # Other scopes may use custom stacks.
  # scope "/api", Zizhixi do
  #   pipe_through :api
  # end
end
