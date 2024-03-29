defmodule MololineWeb.Router do
  use MololineWeb, :router

  import MololineWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MololineWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MololineWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  # scope "/api", MololineWeb do
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
      live_dashboard "/dashboard", metrics: MololineWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", MololineWeb do
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

  scope "/", MololineWeb do
    pipe_through [:browser, :require_authenticated_user]
    get "/", PageController, :index
    resources "/parcels", ParcelController
    resources "/parceldeliverybooking", ParcelDeliveryBookingController
    resources "/travelnotices", TravelNoticeController
    post "/travelnotices_index", TravelNoticeController,:index

    resources "/items", ItemController
    resources "/bookings", BookingController
    # customer
    get "/customer_parcels", ParcelController,:customer_index
    get "/customer_bookings", BookingController,:customer_index
    get "/customer_parcel_delivery_bookings",ParcelDeliveryBookingController,:customer_index
    get "/customer_items", ItemController,:customer_index
    live "/bookinglive/:travelnotice_id", BookingLive
    live "/parceldeliverybookinglive/:travelnotice_id/:user_id", ParcelDeliveryBookingLive
    # hr
    live "/hrlive", HrLive
    # accountant
    resources "/items", ItemController
    live "/accountantlive/:accountantemail", AccountantLive
    #conductor or driver
    live "/conductorlive/:travelnotice_id", ConductorLive
    get "/travelnoticesfordriver", TravelNoticeController,:driver

    #manager
    resources "/sales", SaleController
    resources "/seatplans", SeatplanController
    resources "/towns", TownController
    resources "/vehicles", VehicleController

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", MololineWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
