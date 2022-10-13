defmodule MololineWeb.ConductorLive do
  use Phoenix.LiveView


  alias Mololine.Repo
  alias Mololine.Notices
  alias Mololine.Notices.TravelNotice
  alias Mololine.Bookings
  alias Mololine.Bookings.Booking
  alias Mololine.ParcelBookings.ParcelDeliveryBooking

  def mount((%{"travelnotice_id" => travelnotice_id}),session,socket) do
    bookings = Repo.all(Booking,travelnotice_id: travelnotice_id) |> Repo.preload(:user)
    parcels = Repo.all(ParcelDeliveryBooking,travelnotice_id: travelnotice_id) |>Repo.preload(:travelnotice)
    #changeset = Bookings.change_booking(%Booking{})
    #socket = assign(socket,:changeset,changeset)
    socket = assign(socket,:bookings,bookings)
    socket = assign(socket,:parcels,parcels)
   # IO.inspect bookings.user.firstname
#user=bookings.firstname
    IO.inspect bookings
    IO.inspect parcels

#firstname=user.firstname
#    IO.puts "sdff"

      {:ok, socket}
    end
  def handle_event("submit_booking", payload,socket) do
    IO.inspect payload["booking_id"]
    booking = Repo.get_by(Booking,booking_id: payload["booking_id"])
    socket = assign(socket,:booking,booking)

    if(booking == nil) do
      IO.puts("nil booking")
      {:noreply, put_flash(socket, :error, "Booking with that booking id not found")}
      else
      IO.puts("in else")
      #booking.checked_in=true
      IO.inspect payload
      booking = socket.assigns.booking
      result = (Bookings.update_booking_checkin(booking,%{"checked_in" => true})
                |> Repo.update!())
      IO.inspect result
      socket =  socket |> put_flash(:info, "Updated Booking details Successfully")
      {:noreply,socket}

    end
    {:noreply, socket}
  end

  def handle_event("submit_parcel_booking", payload,socket) do
    IO.inspect payload["booking_id"]
    booking = Repo.get_by(Booking,booking_id: payload["booking_id"])
    socket = assign(socket,:booking,booking)

    if(booking == nil) do
      IO.puts("nil booking")
      {:noreply, put_flash(socket, :error, "Booking with that booking id not found")}
    else
      IO.puts("in else")
      #booking.checked_in=true
      IO.inspect payload
      booking = socket.assigns.booking
      result = (Bookings.update_booking_checkin(booking,%{"checked_in" => true})
                |> Repo.update!())
      IO.inspect result
      socket =  socket |> put_flash(:info, "Updated Booking details Successfully")
      {:noreply,socket}

    end
    {:noreply, socket}
  end
end