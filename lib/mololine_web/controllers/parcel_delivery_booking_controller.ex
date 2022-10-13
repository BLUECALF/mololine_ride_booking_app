defmodule MololineWeb.ParcelDeliveryBookingController do
  use MololineWeb, :controller

  alias Mololine.ParcelBookings
  alias Mololine.Resources.Parcel
  alias Mololine.ParcelBookings.ParcelDeliveryBooking

  def index(conn, _params) do
    parceldeliverybooking = ParcelBookings.list_parceldeliverybooking()
    render(conn, "index.html", parceldeliverybooking: parceldeliverybooking)
  end

  def new(conn, parcel_booking_params) do
    IO.puts "booking params in new parcel deliv is "
    IO.inspect parcel_booking_params
    changeset = ParcelBookings.change_parcel_delivery_booking(%ParcelDeliveryBooking{})
    render(conn, "new.html", [changeset: changeset, parcel_booking_params: parcel_booking_params])
  end

  def create(conn, %{"parcel_delivery_booking" => parcel_delivery_booking_params}) do
    IO.inspect parcel_delivery_booking_params
    travelnotice_id = parcel_delivery_booking_params["travelnotice_id"]
    travelnotice = Mololine.Notices.get_travel_notice!(travelnotice_id)
    parcel_unique_id = parcel_delivery_booking_params["parcel_unique_id"]
    parcel = Mololine.Resources.get_parcel!(parcel_unique_id)
    case ParcelBookings.create_parcel_delivery_booking(parcel_delivery_booking_params,parcel,travelnotice) do
      {:ok, parcel_delivery_booking} ->
        conn
        |> put_flash(:info, "Parcel delivery booking created successfully.")
        |> redirect(to: Routes.parcel_delivery_booking_path(conn, :show, parcel_delivery_booking))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    parcel_delivery_booking = ParcelBookings.get_parcel_delivery_booking!(id)
    render(conn, "show.html", parcel_delivery_booking: parcel_delivery_booking)
  end

  def edit(conn, %{"id" => id}) do
    parcel_delivery_booking = ParcelBookings.get_parcel_delivery_booking!(id)
    changeset = ParcelBookings.change_parcel_delivery_booking(parcel_delivery_booking)
    render(conn, "edit.html", parcel_delivery_booking: parcel_delivery_booking, changeset: changeset)
  end

  def update(conn, %{"id" => id, "parcel_delivery_booking" => parcel_delivery_booking_params}) do
    parcel_delivery_booking = ParcelBookings.get_parcel_delivery_booking!(id)

    case ParcelBookings.update_parcel_delivery_booking(parcel_delivery_booking, parcel_delivery_booking_params) do
      {:ok, parcel_delivery_booking} ->
        conn
        |> put_flash(:info, "Parcel delivery booking updated successfully.")
        |> redirect(to: Routes.parcel_delivery_booking_path(conn, :show, parcel_delivery_booking))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", parcel_delivery_booking: parcel_delivery_booking, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    parcel_delivery_booking = ParcelBookings.get_parcel_delivery_booking!(id)
    {:ok, _parcel_delivery_booking} = ParcelBookings.delete_parcel_delivery_booking(parcel_delivery_booking)

    conn
    |> put_flash(:info, "Parcel delivery booking deleted successfully.")
    |> redirect(to: Routes.parcel_delivery_booking_path(conn, :index))
  end
end
