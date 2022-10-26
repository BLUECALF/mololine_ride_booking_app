defmodule MololineWeb.AccountantLive do
  use Phoenix.LiveView
  alias Mololine.Repo
  alias Mololine.Resources.Parcel
  alias Mololine.ParcelBookings.ParcelDeliveryBooking
  alias Mololine.ParcelBookings
  alias Mololine.Inventory.Item
  alias Mololine.Inventory
  alias Mololine.Accounts.User
  alias Mololine.Accounts

  def mount((%{"accountantemail" => accountantemail}),session,socket) do
    first_form_passed = false
    socket = assign(socket,:first_form_passed,first_form_passed)
    socket = assign(socket,:parcels,nil)
    socket = assign(socket,:accountantemail,accountantemail)
    socket = assign(socket,:transportableparcels,nil)
    socket = assign(socket,:parcels_to_receive,nil)
    case connected?(socket) do
      true ->
        #subscribe to the channel
        Phoenix.PubSub.subscribe(Mololine.PubSub,"accountantlive#{accountantemail}")
        IO.puts("accountant subscribed to :: accountantlive#{accountantemail}")
      false ->
        # Only subscribes when Live View is connected via socket
        IO.puts("socket is not connected.")
    end
    {:ok, socket}
  end


  def handle_event("submit", payload,socket) do
    IO.inspect payload["parcel_id"]
    item = Repo.get_by(Item,parcel_id: payload["parcel_id"])

    if(item===nil) do
      {:noreply, put_flash(socket, :error, "Item With that parcel ID not found")}
      else
      socket = assign(socket,:item,item)
      socket = assign(socket,:first_form_passed,!socket.assigns.first_form_passed)
      {:noreply,socket}
    end
  end

  def handle_event("give_conductor_parcels", payload,socket) do

    checkedoutparcels = payload["checkedoutparcels"]
    # checkout the given out parcels.
     for parcelid <- checkedoutparcels do
      #change parcel id   to integer

      item = Repo.get_by(Item, parcel_id: String.to_integer(parcelid))
      #delete item of that parcel id
      Repo.delete!(item)
      #update the parcel delivery booking
      pDBooking = Repo.get_by(ParcelDeliveryBooking,booking_id: item.parcel_booking_id)
      {:ok,_} = (ParcelBookings.update_parcel_delivery_booking(pDBooking,%{"checked_in" => true})
       |> Repo.update!())
    end

    # provide the parcel signal to conductor
    broadcast("accountantlive#{socket.assigns.accountantemail}",:conductor_given_parcel,[])
    socket =  socket |> put_flash(:info, "System has asked Accountant For the Parcels")
    {:noreply,socket}
  end
  def handle_info({:conductor_requested_parcel, payload},socket) do
    IO.puts "conductor requested parcels"
    IO.inspect payload
    parcelList = for parcelid <- payload do
      #change parcel id   to integer
      Repo.get(Parcel, String.to_integer(parcelid))
    end

    # check if they can be checked  into the vehicle.
    transportableparcelList = for parcelid <- payload do
      #change parcel id   to integer

      item = Repo.get_by(Item, parcel_id: String.to_integer(parcelid))
      if(item == nil) do

        else
        IO.inspect item
        booking_id = item.parcel_booking_id
        booking_id = removeNil(booking_id)
        pDBooking = Repo.get_by(ParcelDeliveryBooking,booking_id: booking_id)
        if(pDBooking == nil) do
        else
          pDBooking
          Repo.get(Parcel,pDBooking.parcel_unique_id)
        end
      end

    end
    # wait for conductor to acknowledge.
    socket = assign(socket,:parcels,parcelList)
    socket = assign(socket,:transportableparcels,transportableparcelList)
    {:noreply,socket}
  end

  def handle_info({:conductor_requested_to_give_parcel, payload},socket) do
    IO.puts "conductor requested  to give parcels"
    IO.inspect payload
    parcelList = for parcelid <- payload do
      #change parcel id   to integer
      Repo.get(Parcel, String.to_integer(parcelid))
    end
    socket = assign(socket,:parcels_to_receive,parcelList)
    {:noreply,socket}
  end

  def handle_event("receive_parcels_from_conductor", payload,socket) do

    checkedinparcels = payload["checkedinparcels"]
    # checkout the given out parcels.
    for parcelid <- checkedinparcels do

      parcel_id =  String.to_integer(parcelid)
      # steps make item for that parcel
      Inventory.create_item(%{parcel_id: parcel_id,town: "nakuru"})
      # change =it to checked out true & delivered true.
      import Ecto.Query, only: [from: 2]

      # Create a query
      query = from pdb in "parceldeliverybooking",
                   where: pdb.parcel_unique_id == ^parcel_id and pdb.checked_in == true and pdb.checked_out == false,
                   select: pdb.id

      # Send the query to the repository
      pdb_id  = List.first(Repo.all(query))
      pDBooking  = Repo.get(ParcelBookings.ParcelDeliveryBooking,pdb_id)
      {:ok,_} = (ParcelBookings.update_parcel_delivery_booking(pDBooking,%{"checked_out" => true,"delivered" => true,})
                 |> Repo.update!())
    end

    # provide the parcel signal to conductor
    broadcast("accountantlive#{socket.assigns.accountantemail}",:conductor_given_parcel,[])
    socket =  socket |> put_flash(:info, "Parcel checked in Successfully ")
    {:noreply,socket}
  end

  defp broadcast(topic,event,payload) do
    Phoenix.PubSub.broadcast(Mololine.PubSub,topic,{event, payload})
  end


  def removeNil(booking_id) do
    if(booking_id == nil) do
      0
      else
      booking_id
    end
    end
end