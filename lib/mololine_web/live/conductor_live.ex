defmodule MololineWeb.ConductorLive do
  use Phoenix.LiveView


  alias Mololine.Repo
  alias Mololine.Notices
  alias Mololine.Notices.TravelNotice
  alias Mololine.Bookings.Booking
  def mount((%{"travelnotice_id" => travelnotice_id}),session,socket) do
    IO.puts("Travel notice Id in conductor live is #{travelnotice_id}")
    travelnotice = Repo.get_by(TravelNotice,id: travelnotice_id) |>Repo.preload(:bookings)
    bookings  = travelnotice.bookings
    socket = assign(socket,:bookings,bookings)
      {:ok, socket}
    end
end