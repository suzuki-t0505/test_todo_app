defmodule TestTodoAppWeb.Router do
  use TestTodoAppWeb, :router

  import TestTodoAppWeb.AccountAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TestTodoAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_account
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestTodoAppWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TestTodoAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:test_todo_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TestTodoAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", TestTodoAppWeb do
    pipe_through [:browser, :redirect_if_account_is_authenticated]

    live_session :redirect_if_account_is_authenticated,
      on_mount: [{TestTodoAppWeb.AccountAuth, :redirect_if_account_is_authenticated}] do
      live "/accounts/register", AccountRegistrationLive, :new
      live "/accounts/log_in", AccountLoginLive, :new
      live "/accounts/reset_password", AccountForgotPasswordLive, :new
      live "/accounts/reset_password/:token", AccountResetPasswordLive, :edit
    end

    post "/accounts/log_in", AccountSessionController, :create
  end

  scope "/", TestTodoAppWeb do
    pipe_through [:browser, :require_authenticated_account]

    live_session :require_authenticated_account,
      on_mount: [{TestTodoAppWeb.AccountAuth, :ensure_authenticated}] do
      live "/accounts/settings", AccountSettingsLive, :edit
      live "/accounts/settings/confirm_email/:token", AccountSettingsLive, :confirm_email
    end
  end

  scope "/", TestTodoAppWeb do
    pipe_through [:browser]

    delete "/accounts/log_out", AccountSessionController, :delete

    live_session :current_account,
      on_mount: [{TestTodoAppWeb.AccountAuth, :mount_current_account}] do
      live "/accounts/confirm/:token", AccountConfirmationLive, :edit
      live "/accounts/confirm", AccountConfirmationInstructionsLive, :new
    end
  end
end
