defmodule MololineWeb.ConductorLive do
  use Phoenix.LiveView


  alias Mololine.Repo
  alias Mololine.Notices
  alias Mololine.Sales.Sale
  alias Mololine.Sales
  alias Mololine.Accounts.User
  alias Mololine.Notices.TravelNotice
  alias Mololine.Bookings
  alias Mololine.ParcelBookings
  alias Mololine.Bookings.Booking
  alias Mololine.ParcelBookings.ParcelDeliveryBooking
  alias Mololine.Resources.Parcel

  def mount((%{"travelnotice_id" => travelnotice_id}),session,socket) do
    bookings = Repo.all(Booking,travelnotice_id: travelnotice_id) |> Repo.preload(:user)
    parcels = Repo.all(ParcelDeliveryBooking,travelnotice_id: travelnotice_id) |>Repo.preload(:parcel)
    #changeset = Bookings.change_booking(%Booking{})
    #socket = assign(socket,:changeset,changeset)
    socket = assign(socket,:bookings,bookings)
    socket = assign(socket,:parcels,parcels)
    socket = assign(socket,:travelnotice_id,travelnotice_id)
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
      {:noreply, put_flash(socket, :error, "seat Booking with that booking id not found")}
      else
      if(booking.checked_in == true) do
        # inform user that the booking has already been checked in
        socket =  socket |> put_flash(:error, "The booking ID has already been checked in")
        socket = updatePage(socket)
        {:noreply,socket}
        else
        IO.puts("in else")
        #booking.checked_in=true
        IO.inspect payload
        booking = socket.assigns.booking
        result = (Bookings.update_booking_checkin(booking,%{"checked_in" => true})
                  |> Repo.update!())
        IO.inspect result
        socket =  socket |> put_flash(:info, "Checked into seat Successfully")
        socket = updatePage(socket)
        # add the record to sales
        user = Repo.get_by(User,id: booking.user_id)
        attrs = %{
          "from"=> user.firstname <> " "<> user.lastname,
          "to"=>   "Mololine Services",
          "amount"=> booking.total_price,
          "reason"=>"Seat booking #{booking.seat}",
          "date"=> DateTime.utc_now() ,
        }
        IO.inspect attrs
        Sales.create_sale(attrs)
        {:noreply,socket}
      end
    end
  end

  def handle_event("submit_parcel_road_checkin", payload,socket) do
    IO.inspect payload["booking_id"]
    pRBooking = Repo.get_by(ParcelDeliveryBooking,booking_id: payload["booking_id"])
    socket = assign(socket,:pRBooking,pRBooking)

    if(pRBooking == nil or pRBooking.pickuppoint != "Custom Location") do
      IO.puts("nil booking")
      {:noreply, put_flash(socket, :error, "Parcel delivery booking with that booking id not found or was to be picked at office")}
    else
      #booking.checked_in=true
      pRBooking = socket.assigns.pRBooking
      {:ok,result} = (ParcelBookings.update_parcel_delivery_booking(pRBooking,%{"checked_in" => true}))

      # make it into a sale
      parcel = Repo.get_by(Parcel,id: pRBooking.parcel_id)
      user = Repo.get_by(User,id: parcel.user_id)
      attrs = %{
        "from"=> user.firstname <> " "<> user.lastname,
        "to"=>   "Mololine Services",
        "amount"=> round(((parcel.weight/1000) * Repo.get(Mololine.Notices.TravelNotice,pRBooking.travelnotice_id).price/5)),
        "reason"=>"Parcel Delivery booking #{pRBooking.booking_id}",
        "date"=> DateTime.utc_now() ,
      }

      Sales.create_sale(attrs)

      socket =  socket |> put_flash(:info, "Checked in parcel Successfully on Road ")
      socket = updatePage(socket)
      {:noreply,socket}
    end
  end

  def handle_event("submit_parcel_office_checkin", payload,socket) do
    IO.puts " the Payload is \n"
    IO.inspect payload
    accountantemail = payload["accountantemail"]
    parcelList = payload["parcelList"]
    case connected?(socket) do
      true ->
        #subscribe to the channel
        Phoenix.PubSub.subscribe(Mololine.PubSub,"accountantlive#{accountantemail}")
        IO.puts("conductor/driver subscribed to :: accountantlive#{accountantemail}")
      false ->
        # Only subscribes when Live View is connected via socket
        IO.puts("socket is not connected.")
     end

     # broadcast to ask for the parcels.
     broadcast("accountantlive#{accountantemail}",:conductor_requested_parcel,parcelList)
      socket =  socket |> put_flash(:info, "System has asked Accountant For the Parcels")
      {:noreply,socket}
  end

  def handle_event("submit_road_parcel_checkout", payload,socket) do
    IO.puts "The payload in parcel submit to road is \n\n"
    IO.inspect payload
    #pina=parcel.pin
    parcel=Repo.get_by(Parcel,id: payload["parcel_id"])
    #IO.inspect parcel.pin
    if (parcel==nil) do
      IO.puts("parcel with that id does not exist")
      {:noreply, put_flash(socket, :error, "parcel with that id does not exist")}
    else
      if(parcel.pin==payload["pin"]) do
        pOBookingR = Repo.get_by(ParcelDeliveryBooking,parcel_id: parcel.id)
        socket = assign(socket,:pOBookingR,pOBookingR)
        if(pOBookingR == nil) do
          IO.puts("nil parcel checkout")
          {:noreply, put_flash(socket, :error, "parcel checkout with that parcel id not found")}
        else
          IO.puts("in else")
          #booking.checked_in=true
          IO.inspect payload
          pOBookingR = socket.assigns.pOBookingR
          result = (ParcelBookings.update_parcel_delivery_booking(pOBookingR,%{"checked_out" => true})
                    |> Repo.update!())
          IO.inspect result
          socket =  socket |> put_flash(:info, "Checked out parcel Successfully on Road ")
          socket = updatePage(socket)
          {:noreply,socket}
        end
      else
        IO.puts("Parcel details do not match")
        socket =  socket |> put_flash(:error, "Parcel details do not match, contact the parcel sender for pin")
        {:noreply,socket}
      end
    end
  end

  def handle_event("submit_parcel_office_checkout", payload,socket) do
    IO.puts " the Payload in parcel office checkout is \n"
    IO.inspect payload
    accountantemail = payload["accountantemail"]
    parcelList = payload["parcelList"]

    # broadcast to ask  to give parcels
    broadcast("accountantlive#{accountantemail}",:conductor_requested_to_give_parcel,parcelList)

    # subscribe to chanel
    case connected?(socket) do
      true ->
        #subscribe to the channel
        Phoenix.PubSub.subscribe(Mololine.PubSub,"accountantlive#{accountantemail}")
        IO.puts("conductor/driver subscribed to :: accountantlive#{accountantemail}")
      false ->
        # Only subscribes when Live View is connected via socket
        IO.puts("socket is not connected.")
    end
    socket =  socket |> put_flash(:info, "System has asked Accountant to Receive")
    {:noreply,socket}
  end

  def handle_info({:conductor_given_parcel, payload},socket) do
    socket = updatePage(socket)
    socket =  socket |> put_flash(:info, "I received the parcel Successfully")
    {:noreply,socket}
  end

  defp updatePage(socket) do
    travelnotice_id = socket.assigns.travelnotice_id
    bookings = Repo.all(Booking,travelnotice_id: travelnotice_id) |> Repo.preload(:user)
    parcels = Repo.all(ParcelDeliveryBooking,travelnotice_id: travelnotice_id) |>Repo.preload(:parcel)
    socket = assign(socket,:bookings,bookings)
    socket = assign(socket,:parcels,parcels)
    socket
  end

  defp broadcast(topic,event,payload) do
    Phoenix.PubSub.broadcast(Mololine.PubSub,topic,{event, payload})
  end
end