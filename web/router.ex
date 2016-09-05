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

    get "/users/:username/edit/:action", UserController, :edit
    patch "/users/:username/edit/:action", UserController, :update
    put "/users/:username/edit/:action", UserController, :update, as: nil

    resources "/groups", GroupController do
      resources "/members", GroupMemberController, as: :member, only: [:index, :create]

      resources "/posts", GroupPostController, as: :post, only: [:index, :new, :create]
    end

    resources "/groups_members", GroupMemberController, only: [:delete]

    resources "/groups_posts", GroupPostController, only: [:edit, :update, :delete] do
      resources "/comments", GroupCommentController, as: :comment, only: [:create, :show]
    end

    resources "/group_comments", GroupCommentController, only: [:delete]
  end

  scope "/account", Zizhixi do
    pipe_through [:browser, :browser_session]

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create

    get "/signout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Zizhixi do
  #   pipe_through :api
  # end
end
