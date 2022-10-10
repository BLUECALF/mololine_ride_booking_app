defmodule MololineWeb.ConductorLive do
  use Phoenix.LiveView


  alias Mololine.Repo
  alias Mololine.Notices
  alias Mololine.Notices.TravelNotice
  alias Mololine.Bookings.Booking
  def mount((%{"travelnotice_id" => travelnotice_id}),session,socket) do
    bookings = Repo.all(Booking,travelnotice_id: travelnotice_id)
    IO.inspect bookings
      {:ok, socket}
    end
end