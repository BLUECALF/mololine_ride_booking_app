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
  alias Mololine.Sales

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
      {:ok,_pdb}=(ParcelBookings.update_parcel_delivery_booking(pDBooking,%{"checked_in" => true}))

      parcel = Repo.get_by(Parcel,id: pDBooking.parcel_id)
      user = Repo.get_by(User,id: parcel.user_id)
      attrs = %{
        "from"=> user.firstname <> " "<> user.lastname,
        "to"=>   "Mololine Services",
        "amount"=> round(((parcel.weight/1000) * Repo.get(Mololine.Notices.TravelNotice,pDBooking.travelnotice_id).price/5)),
        "reason"=>"Parcel Delivery booking #{pDBooking.booking_id}",
        "date"=> DateTime.utc_now() ,
      }
      IO.inspect attrs
      Sales.create_sale(attrs)
    end

    # provide the parcel signal to conductor
    broadcast("accountantlive#{socket.assigns.accountantemail}",:conductor_given_parcel,[])

    {:noreply,socket}
  end

  # functions to remove errors
  def handle_info({:conductor_given_parcel, payload},socket) do
    socket =  socket |> put_flash(:info, "Given Conductor parcels Successfully")
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
        accountant = Repo.get_by(User,email: socket.assigns.accountantemail) |> Repo.preload(:town)
        if(pDBooking == nil or (pDBooking != nil and item.town != accountant.town.name)) do
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
      accountant_email = socket.assigns.accountantemail
      user = Repo.get_by(User,email: accountant_email) |> Repo.preload(:town)
      Inventory.create_item(%{parcel_id: parcel_id,town: user.town.name})
      # change =it to checked out true & delivered true.
      import Ecto.Query, only: [from: 2]

      # Create a query
      query = from pdb in "parceldeliverybooking",
                   where: pdb.parcel_unique_id == ^parcel_id and pdb.checked_in == true and pdb.checked_out == false,
                   select: pdb.id

      # Send the query to the repository
      pdb_id  = List.first(Repo.all(query))
      pDBooking  = Repo.get(ParcelBookings.ParcelDeliveryBooking,pdb_id)
      {:ok,_} = (ParcelBookings.update_parcel_delivery_booking(pDBooking,%{"checked_out" => true,"delivered" => true,}))
    end

    # provide the parcel signal to conductor
    broadcast("accountantlive#{socket.assigns.accountantemail}",:conductor_given_parcel,[])
    socket =  socket |> put_flash(:info, "Parcel checked in Successfully ")
    {:noreply,socket}
  end

  def handle_event("remove_parcel_from_office", payload,socket) do
    parcel=Repo.get_by(Parcel,id: payload["parcel_id"])
    item = Repo.get_by(Item,parcel_id: payload["parcel_id"])
    user = Repo.get_by(User,email: socket.assigns.accountantemail) |> Repo.preload(:town)
    if (parcel==nil or item == nil or (item.town != user.town.name)) do
      {:noreply, put_flash(socket, :error, "parcel with ID #{payload["parcel_id"]} does not exist in #{user.town.name} office")}
    else
      if(parcel.pin==payload["pin"]) do
        # delete  the data
        {:ok, _item} = Inventory.delete_item(item)
          socket =  socket |> put_flash(:info, "Removed parcel successfully from office ")
          {:noreply,socket}
      else
        IO.puts("Parcel details do not match")
        socket =  socket |> put_flash(:error, "Parcel details do not match, contact the parcel sender for pin")
        {:noreply,socket}
      end
    end
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