defmodule MololineWeb.ParcelDeliveryBookingLive do
  use Phoenix.LiveView

  alias Mololine.Repo
  alias Mololine.Notices
  alias Mololine.Towns.Town
  alias Mololine.Accounts.User
  alias Mololine.Notices.TravelNotice
  alias Mololine.Resources.Parcel
  alias Mololine.Bookings.Booking
  alias MololineWeb.Router.Helpers, as: Routes

  def mount((%{"travelnotice_id" => travelnotice_id,"user_id" => user_id}),session,socket) do

    travelnotice = Repo.get_by(TravelNotice,id: travelnotice_id) |>Repo.preload(:vehicle)
    vehicle = travelnotice.vehicle
    user = Repo.get_by(User, id: user_id) |> Repo.preload(:parcels)
    parcel_list = user.parcels
    town_list = Repo.all(Town)
    case connected?(socket) do
      true ->
      #subscribe to the channel
        Phoenix.PubSub.subscribe(Mololine.PubSub,"parceldeliverybookinglive#{travelnotice_id}")
      false ->
        # Only subscribes when Live View is connected via socket
        IO.puts("socket is not connected.")
    end

    # we need parcel information and towns information.
    socket = assign(socket,:travelnotice,travelnotice)
    socket = assign(socket,:parcel_list,parcel_list)
    socket = assign(socket,:town_list,town_list)
    {:ok, socket}
  end

  def handle_info({:update_booking, bookings},socket) do
    socket = assign(socket,:bookings,bookings)
    {:noreply,socket}
  end

  def handle_event("book", _payload,socket) do
    {:noreply,push_redirect(socket, to: Routes.parcel_delivery_booking_path(socket, :new, "booking_params"))}
  end

  def handle_event("select", payload,socket) do
    IO.puts "THE PAYLOAD IX"
    IO.inspect payload
  end

  defp broadcast(topic,event,payload) do
    Phoenix.PubSub.broadcast(Mololine.PubSub,topic,{event, payload})
  end

end
