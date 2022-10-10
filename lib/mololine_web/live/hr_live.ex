defmodule MololineWeb.HrLive do
  use Phoenix.LiveView
  alias Mololine.Repo
  alias Mololine.Accounts.User
  alias Mololine.Accounts

  def mount(params,session,socket) do
    role = ""
    first_form_passed = false
    changeset = Accounts.change_user_registration(%User{})
    socket = assign(socket,:role,role)
    socket = assign(socket,:first_form_passed,first_form_passed)
    socket = assign(socket,:changeset,changeset)
    #socket = assign(socket,:user,user)
    {:ok, socket}
  end


  def handle_event("submit", payload,socket) do
    IO.puts("submit from hr")
    IO.inspect payload["email"]
    user = Repo.get_by(User,email: payload["email"])
    IO.puts("unknown user")
    IO.inspect user
    if(user===nil) do
      IO.puts("nil user")
      {:noreply, put_flash(socket, :error, "User with that email not found")}
      #socket =
       # socket
        #|> put_flash(:error, "no user found with that email")
      #{:noreply,socket}
      else
      socket = assign(socket,:user,user)
      socket = assign(socket,:first_form_passed,true)
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