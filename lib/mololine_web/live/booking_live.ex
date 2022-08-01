defmodule MololineWeb.BookingLive do
  use Phoenix.LiveView

  alias Mololine.Repo
  alias Mololine.Notices
  alias Mololine.Notices.TravelNotice
  alias Mololine.Bookings.Booking

  def mount((%{"travelnotice_id" => travelnotice_id}),_session,socket) do
    IO.puts("PARAMETER PASSED TO BOOKINGLIVE")
    IO.inspect (%{"travelnotice_id" => travelnotice_id})
    travelnotice = Repo.get_by(TravelNotice,id: travelnotice_id) |>Repo.preload(:vehicle)
    vehicle = travelnotice.vehicle |> Repo.preload(:seatplan)
    seats = vehicle.seatplan.seats
    bookings = Repo.all(Booking,travelnotice_id: travelnotice_id)
    IO.puts " Travel notice is  "
    IO.inspect travelnotice
    IO.puts "Seats is "
    IO.inspect seats
    IO.puts "Bookings are "
    IO.inspect bookings
    case connected?(socket) do
      true ->
        Phoenix.PubSub.subscribe(Mololine.PubSub,"update_count")
      false ->
        # Only subscribes when Live View is connected via socket
        IO.puts("socket is not connected.")
    end
    socket = assign(socket,:count,0)
    socket = assign(socket,:travelnotice,travelnotice)
    socket = assign(socket,:seats,seats)
    socket = assign(socket,:bookings,bookings)
    {:ok, socket}
  end


  def handle_event("add", payload, socket) do
    count = socket.assigns.count + 1
    #socket = assign(socket,:count,count)
    broadcast_count(count)
    IO.puts "add happend"
    {:noreply, socket}
  end
  def handle_event("minus", payload, socket) do
    count = socket.assigns.count - 1
    #socket = assign(socket,:count,count)
    broadcast_count(count)
    IO.puts "minus happended"
    {:noreply, socket}
  end

  def handle_info({:update_count, count},socket) do
    socket = assign(socket,:count,count)
    {:noreply,socket}
  end

  defp broadcast_count(count) do
    Phoenix.PubSub.broadcast(Mololine.PubSub,"update_count",{:update_count, count})
  end

end
