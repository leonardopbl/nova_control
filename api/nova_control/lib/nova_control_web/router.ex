defmodule NovaControlWeb.Router do
  use NovaControlWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:nova_control, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: NovaControlWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  scope "/api", NovaControlWeb do
    pipe_through(:api)

    get("/status", StatusController, :index)

    get("/users", UsersController, :index)
    put("/users/:id", UsersController, :update)
    delete("/users/:id", UsersController, :delete)

    get("/expenses", ExpensesController, :index)
    post("/expenses", ExpensesController, :create)
    put("/expenses/:id", ExpensesController, :update)
  end

  scope "/api/auth", NovaControlWeb do
    pipe_through(:api)

    post("/signup", AuthController, :signup)
    post("/login", SessionController, :login)
  end
end
