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
    plug Zizhixi.Plug.LoadCurrentUser
  end

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Zizhixi do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    post "/upload", PageController, :upload

    get "/", PageController, :index

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create

    get "/signout", SessionController, :delete

    resources "/users", UserController, param: "username", only: [:show] do
      resources "/follow", UserFollowController, as: :follow, only: [:create, :delete], singleton: true
      resources "/events", UserEventController, as: :event, only: [:index]
      resources "/timelines", UserTimelineController, as: :timeline, only: [:index]
    end

    resources "/groups", GroupController do
      resources "/members", GroupMemberController, as: :member, only: [:index]
      resources "/members", GroupMemberController, as: :member, only: [:create, :delete], singleton: true
      resources "/posts", GroupPostController, as: :post, only: [:new, :create]
      resources "/topics", GroupTopicController, as: :topic, only: [:index, :new, :create]
    end

    resources "/group_posts", GroupPostController, only: [:show, :edit, :update] do
      resources "/praise", GroupPostPraiseController, as: :praise, only: [:create, :delete], singleton: true
      resources "/collect", GroupPostCollectController, as: :collect, only: [:create, :delete], singleton: true
      resources "/watch", GroupPostWatchController, as: :watch, only: [:create, :delete], singleton: true
      resources "/comments", GroupCommentController, as: :comment, only: [:create, :show]
      resources "/elite", GroupPostEliteController, as: :elite, only: [:create, :delete], singleton: true
      resources "/top", GroupPostTopController, as: :top, only: [:create, :delete], singleton: true
    end

    resources "/group_topics", GroupTopicController, only: [:edit, :update, :delete]

    resources "/group_comments", GroupCommentController, only: [:edit, :update, :delete] do
      resources "/praise", GroupCommentPraiseController, as: :praise, only: [:create, :delete], singleton: true
    end

    resources "/asks", AskController
    resources "/tutorials", TutorialController
    resources "/links", LinkController
    resources "/markets", MarketController
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
