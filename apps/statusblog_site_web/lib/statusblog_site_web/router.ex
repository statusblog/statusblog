defmodule StatusblogSiteWeb.Router do
  use StatusblogSiteWeb, :router
  import StatusblogSiteWeb.DomainPlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_blog
    plug :require_current_blog
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StatusblogSiteWeb do
    pipe_through :browser

    get "/", PageController, :index

    post "/subscriptions/new", SubscriptionController, :create
    get "/subscriptions/confirm/:token", SubscriptionController, :confirm
    get "/subscriptions/unsubscribe/:token", SubscriptionController, :unsubscribe
    # get "/subscriptions/:token", SubscriptionController, :edit
    # put "/subscriptions/:token", SubscriptionController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", StatusblogSiteWeb do
  #   pipe_through :api
  # end
end
