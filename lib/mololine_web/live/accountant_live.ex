defmodule MololineWeb.AccountantLive do
  use Phoenix.LiveView
  alias Mololine.Repo
  alias Mololine.Inventory.Item
  alias Mololine.Inventory
  alias Mololine.Accounts.User
  alias Mololine.Accounts

  def mount(params,session,socket) do
    first_form_passed = false
    socket = assign(socket,:first_form_passed,first_form_passed)
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
  def handle_event("update", payload,socket) do
    IO.puts("Payload in update")
    IO.inspect payload
    user = socket.assigns.user
    result = (User.update_user_changeset(user,payload)
              |> Repo.update!())
     socket =  socket |> put_flash(:info, "Updated User details Successfully")
      {:noreply,socket}

  end
end