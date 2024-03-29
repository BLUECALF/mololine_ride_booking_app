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
    socket = assign(socket,:custom_pickuppoint,false)
    socket = assign(socket,:custom_droppoint,false)
    socket = assign(socket,:user,user)
    {:ok, socket}
  end

  def handle_info({:update_booking, bookings},socket) do
    socket = assign(socket,:bookings,bookings)
    {:noreply,socket}
  end


  def handle_event("select_parcel", payload,socket) do
    socket = assign(socket,:parcel_unique_id,payload["value"])
    {:noreply,socket}
  end

  def handle_event("submit", payload,socket) do
    IO.puts "The  liveview Form was submitted "
    IO.inspect payload
    parcel_booking_params= Map.put(payload,"travelnotice_id", socket.assigns.travelnotice.id)
    {:noreply,push_redirect(socket, to: Routes.parcel_delivery_booking_path(socket, :new, parcel_booking_params))}
  end
  def handle_event("select_pickuppoint", payload,socket) do
    IO.puts "THE PAYLOAD in pickup point is"
    IO.inspect payload
    socket = assign(socket,:pickuppoint,payload["value"])
    # check if that pickup point has that parcel.
    pickuppoint = payload["value"]
    if (checkIfLocationHasParcel(pickuppoint,String.to_integer(socket.assigns.parcel_unique_id)) and pickuppoint != "Custom Location") do
      # if the parcel is contained in that location.
      socket = assign(socket,:custom_pickuppoint,false)
      socket =  socket |> put_flash(:info, "#{payload["value"]} office has a parcel ID #{socket.assigns.parcel_unique_id}")
      {:noreply,socket}
      else
      # if i have selected custom_pickup point make , it true in assigns
      if(payload["value"] == "Custom Location") do
        socket = assign(socket,:custom_pickuppoint,true)
        {:noreply,socket}
      else
       # not custom location and doesnt have the parcel .... error
        socket = assign(socket,:custom_pickuppoint,false)
        socket =  socket |> put_flash(:error, "#{payload["value"]} office doesn't  have parcel ID #{socket.assigns.parcel_unique_id}")
        {:noreply,socket}
      end
    end



  end


  def handle_event("select_droppoint", payload,socket) do
    IO.puts "THE PAYLOAD in drop point is"
    IO.inspect payload
    socket = assign(socket,:droppoint,payload["value"])
    # if i have selected custom_droppoint make , it true in assigns
    if(payload["value"] == "Custom Location") do
      socket = assign(socket,:custom_droppoint,true)
      {:noreply,socket}
    else
      socket = assign(socket,:custom_droppoint,false)
      {:noreply,socket}
    end
  end

  defp broadcast(topic,event,payload) do
    Phoenix.PubSub.broadcast(Mololine.PubSub,topic,{event, payload})
  end

  defp checkIfLocationHasParcel(location,parcel_id) do
    # check if that location has tha parcel
    #if so deny creation of parcelboking.
    import Ecto.Query, only: [from: 2]

    # Create a query
    query = from item in "items",
                 where: item.parcel_id == ^parcel_id and item.town == ^location,
                 select: item.parcel_id

    # Send the query to the repository
    existing  = List.first(Repo.all(query))

    if existing == nil do
      false
    else
      true
    end
  end
end
