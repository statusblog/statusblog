defmodule StatusblogWeb.Router do
  use StatusblogWeb, :router

  import StatusblogWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StatusblogWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", StatusblogWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: StatusblogWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", StatusblogWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", StatusblogWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", HomeController, :index

    live "/blogs/new", BlogLive.New, :new
    live "/blogs/:blog_id", BlogLive.Edit, :edit

    live "/blogs/:blog_id/components", ComponentLive.Index, :index
    live "/blogs/:blog_id/components/new", ComponentLive.New, :new
    live "/blogs/:blog_id/components/:id", ComponentLive.Edit, :edit #, layout: {StatusblogWeb.LayoutView, "live2.html"}

    live "/blogs/:blog_id/incidents", IncidentLive.Index, :index
    live "/blogs/:blog_id/incidents/resolved", IncidentLive.Index, :resolved
    live "/blogs/:blog_id/incidents/new", IncidentLive.New, :new
    live "/blogs/:blog_id/incidents/:incident_id", IncidentLive.Edit, :edit

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", StatusblogWeb do
    pipe_through [:browser, :require_authenticated_unverified_user]

    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
  end

  scope "/", StatusblogWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/", StatusblogWeb do
    pipe_through [:api]

    get "/tls/ask", TlsController, :ask
  end
end
