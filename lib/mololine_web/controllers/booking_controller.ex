defmodule MololineWeb.BookingController do
  use MololineWeb, :controller

  alias Mololine.Bookings
  alias Mololine.Repo
  alias Mololine.Accounts.User
  alias Mololine.Bookings.Booking

  def index(conn, _params) do
    bookings = Repo.all(Booking) |> Repo.preload(:travelnotice)
    # check user if is not admin show him aproperiate data
    if(conn.assigns.current_user.role != "admin" ) do
      # redirect to parcel_customer page
      conn
      |> redirect(to: Routes.booking_path(conn, :customer_index, []))
    else
      #user iz admin
      render(conn, "index.html", bookings: bookings)
    end
  end

  def customer_index(conn, _params) do
    user_id = conn.assigns.current_user.id
    IO.puts "The user id is :#{user_id}"
    user = Repo.get(User,user_id) |> Repo.preload(:bookings)
    bookings_list = user.bookings
    bookings = for booking <- bookings_list do
      Repo.get(Booking,booking.id) |> Repo.preload(:travelnotice)
      end
    render(conn, "index.html", bookings: bookings)
  end

  def new(conn, booking_params) do
    IO.puts "TRAVEL NOTICE ID IN THIS BOOKING IS #{booking_params["travelnotice_id"]}"
    changeset = Bookings.change_booking(%Booking{})
    render(conn, "new.html", [changeset: changeset, booking_params: booking_params])
  end

  def create(conn, %{"booking" => booking_params}) do
    user = conn.assigns.current_user
    travelnotice_id = booking_params["travelnotice_id"]
    travelnotice = Mololine.Notices.get_travel_notice!(travelnotice_id)
    total_price = length(booking_params["seat"]) * travelnotice.price
    {booking_id} = make_random_booking_id()
    # adding booking_id and totalprice to the booking params
    booking_params = Map.put(booking_params, "booking_id",booking_id)
    booking_params = Map.put(booking_params, "total_price",total_price)
    case Bookings.create_booking(booking_params,user,travelnotice) do
      {:ok, booking} ->
      bookings = Repo.all(Booking,travelnotice_id: travelnotice_id)
      Phoenix.PubSub.broadcast(Mololine.PubSub,"bookinglive#{travelnotice_id}",{:update_booking, bookings})
        conn
        |> put_flash(:info, "Booking created successfully.")
        |> redirect(to: Routes.booking_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    booking = Repo.get(Booking,id) |> Repo.preload(:travelnotice)
    render(conn, "show.html", booking: booking)
  end

  def edit(conn, %{"id" => id}) do
    booking = Bookings.get_booking!(id)
    changeset = Bookings.change_booking(booking)
    render(conn, "edit.html", booking: booking, changeset: changeset)
  end

  def update(conn, %{"id" => id, "booking" => booking_params}) do
    booking = Bookings.get_booking!(id)

    case Bookings.update_booking(booking, booking_params) do
      {:ok, booking} ->
        conn
        |> put_flash(:info, "Booking updated successfully.")
        |> redirect(to: Routes.booking_path(conn, :show, booking))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", booking: booking, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    booking = Bookings.get_booking!(id)
    travelnotice_id = booking.travelnotice_id
    {:ok, _booking} = Bookings.delete_booking(booking)
    bookings = Repo.all(Booking,travelnotice_id: travelnotice_id)
    # broadcast the change in the bookings.
    Phoenix.PubSub.broadcast(Mololine.PubSub,"bookinglive#{travelnotice_id}",{:update_booking, bookings})
    conn
    |> put_flash(:info, "Booking deleted successfully.")
    |> redirect(to: Routes.booking_path(conn, :index))
  end
  defp make_random_booking_id() do
    random_number = :rand.uniform(999999999)
    # find booking with this no
    booking_with_no = Repo.get_by(Booking, booking_id: random_number)
    if(booking_with_no != nil) do
    {
     # call itself
     make_random_booking_id()
    }
    else
    {
     random_number
    }
    end
    ## we need to make random booking ids for the bookings that will be used in checkins and ticket validations
  end
end
