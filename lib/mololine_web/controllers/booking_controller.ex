defmodule MololineWeb.BookingController do
  use MololineWeb, :controller

  alias Mololine.Bookings
  alias Mololine.Repo
  alias Mololine.Bookings.Booking

  def index(conn, _params) do
    bookings = Bookings.list_bookings()
    render(conn, "index.html", bookings: bookings)
  end

  def new(conn, booking_params) do
    IO.puts "TRAVEL NOTICE ID IN THIS BOOKING IS #{booking_params["travelnotice_id"]}"
    changeset = Bookings.change_booking(%Booking{})
    render(conn, "new.html", [changeset: changeset, booking_params: booking_params])
  end

  def create(conn, %{"booking" => booking_params}) do
    {booking_id} = make_random_booking_id()
    IO.puts "BOOKING PARAMS ARE"
    IO.inspect booking_params
    # adding booking_id to the booking params
    booking_params = Map.put(booking_params, "booking_id",booking_id)
    IO.puts "BOOKING PARAMS ARE"
    IO.inspect booking_params
    user = conn.assigns.current_user
    travelnotice_id = booking_params["travelnotice_id"]
    travelnotice = Mololine.Notices.get_travel_notice!(travelnotice_id)
    case Bookings.create_booking(booking_params,user,travelnotice) do
      {:ok, booking} ->
      IO.inspect booking
      #booking succeded
      bookings = Repo.all(Booking,travelnotice_id: travelnotice_id)
      Phoenix.PubSub.broadcast(Mololine.PubSub,"bookinglive#{travelnotice_id}",{:update_booking, bookings})
        conn
        |> put_flash(:info, "Booking created successfully.")
        |> redirect(to: Routes.booking_path(conn, :show, booking))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    booking = Bookings.get_booking!(id)
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
    {:ok, _booking} = Bookings.delete_booking(booking)

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
