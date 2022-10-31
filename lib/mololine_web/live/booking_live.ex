defmodule MololineWeb.BookingLive do
  use Phoenix.LiveView


  alias Mololine.Repo
  alias Mololine.Notices
  alias Mololine.Notices.TravelNotice
  alias Mololine.Bookings.Booking
  alias MololineWeb.Router.Helpers, as: Routes

  def mount((%{"travelnotice_id" => travelnotice_id}),session,socket) do
    IO.puts "data in session is"
    IO.inspect session
    IO.inspect (%{"travelnotice_id" => travelnotice_id})
    travelnotice = Repo.get_by(TravelNotice,id: travelnotice_id) |>Repo.preload(:vehicle)
    vehicle = travelnotice.vehicle |> Repo.preload(:seatplan)
    seats = vehicle.seatplan.seats
    bookings = Repo.all(Booking,travelnotice_id: travelnotice_id)
    case connected?(socket) do
      true ->
      #subscribe to the channel
        Phoenix.PubSub.subscribe(Mololine.PubSub,"bookinglive#{travelnotice_id}")
      false ->
        # Only subscribes when Live View is connected via socket
        IO.puts("socket is not connected.")
    end

    socket = assign(socket,:travelnotice,travelnotice)
    socket = assign(socket,:seats,seats)
    socket = assign(socket,:selectedseats,[])
    socket = assign(socket,:othersselectedseats,[])
    socket = assign(socket,:bookings,make_booked_list(bookings))
    {:ok, socket}
  end

  def handle_info({:update_booking, bookings},socket) do
    socket = assign(socket,:bookings,bookings)
    {:noreply,socket}
  end

  def handle_info({:select_seat, others_selected},socket) do
    socket = assign(socket,:othersselectedseats,(socket.assigns.othersselectedseats ++ others_selected))
    {:noreply,socket}
  end
  def handle_event("book", _payload,socket) do
    selected_seats = socket.assigns.selectedseats
    travelnotice_id = socket.assigns.travelnotice.id
    booking_params = %{"seat" => selected_seats,"travelnotice_id" => "#{travelnotice_id}"}

    IO.puts "BOOKING PARAMS IN Live are "
    IO.inspect booking_params

    selectedseats = socket.assigns.selectedseats
    {:noreply,push_redirect(socket, to: Routes.booking_path(socket, :new, booking_params))}
  end

  def handle_event("select", payload,socket) do
    seat  = payload["value"]
    selectedseats = socket.assigns.selectedseats
    if(Enum.member?(selectedseats,seat)) do
      c= selectedseats
      selectedseats = c -- [seat]
      socket = assign(socket,:selectedseats,selectedseats)
      Phoenix.PubSub.broadcast(Mololine.PubSub,"bookinglive#{socket.assigns.travelnotice.id}",{:select_seat, socket.assigns.selectedseats})
      {:noreply,socket}
      else
      c= selectedseats
      selectedseats = c ++ [seat]
      socket = assign(socket,:selectedseats,selectedseats)
      Phoenix.PubSub.broadcast(Mololine.PubSub,"bookinglive#{socket.assigns.travelnotice.id}",{:select_seat, socket.assigns.selectedseats})
      {:noreply,socket}
      end
    # get seat , add to selected seats and re render.
  end

  defp broadcast(topic,event,payload) do
    Phoenix.PubSub.broadcast(Mololine.PubSub,topic,{event, payload})
  end
 # need to check if has the seat,whcih is booked%>
defp isbooked(list,seat) do
    for item <- list do
        if Enum.member?(item,seat) do
          true
        else
          false
        end
   end
   end
   defp make_booked_list(bookings) do
    booked_seat_list = for booking<- bookings do
        booking.seat
    end
     sum_list(booked_seat_list)
  end
  def sum_list([]) do
    []
  end


  def sum_list([h|t]) do
    h ++ sum_list(t)
  end
end
