defmodule MololineWeb.AccountantLive do
  use Phoenix.LiveView
  alias Mololine.Repo
  alias Mololine.Resources.Parcel
  alias Mololine.Inventory.Item
  alias Mololine.Inventory
  alias Mololine.Accounts.User
  alias Mololine.Accounts

  def mount((%{"accountantemail" => accountantemail}),session,socket) do
    first_form_passed = false
    socket = assign(socket,:first_form_passed,first_form_passed)
    socket = assign(socket,:parcels,nil)
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
    IO.puts "I gave conductor parcels"
    IO.inspect payload

    # checkin each of the parcels

    {:noreply,socket}
  end
  def handle_info({:conductor_requested_parcel, payload},socket) do
    IO.puts "conductor requested parcels"
    IO.inspect payload
    parcelList = for parcelid <- payload do
      #change parcel id   to integer
      Repo.get(Parcel, String.to_integer(parcelid))
    end
    socket = assign(socket,:parcels,parcelList)
    {:noreply,socket}
  end
  defp broadcast(topic,event,payload) do
    Phoenix.PubSub.broadcast(Mololine.PubSub,topic,{event, payload})
  end
end