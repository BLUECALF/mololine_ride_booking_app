defmodule MololineWeb.ParcelDeliveryBookingController do
  use MololineWeb, :controller

  alias Mololine.ParcelBookings
  alias Mololine.Resources.Parcel
  alias Mololine.Repo
  alias Mololine.Accounts.User
  alias Mololine.ParcelBookings.ParcelDeliveryBooking

  def index(conn, _params) do
    parceldeliverybooking = ParcelBookings.list_parceldeliverybooking()
    # check user if is not admin show him aproperiate data
    if(conn.assigns.current_user.role != "admin" ) do
      # redirect to parcel_customer page
      conn
      |> redirect(to: Routes.parcel_delivery_booking_path(conn, :customer_index, []))
    else
      #user iz admin
      render(conn, "index.html", parceldeliverybooking: parceldeliverybooking)
    end
  end

  def customer_index(conn, _params) do
    user_id = conn.assigns.current_user.id
    IO.puts "The user id is :#{user_id}"
    user = Repo.get(User,user_id) |> Repo.preload(:parcels)
    parcels = user.parcels
    parceldeliverybooking_list =  for parcel <- parcels do
      parcel_instance = Repo.get(Parcel,parcel.id) |> Repo.preload(:parceldeliverybookings)
      parcel_instance.parceldeliverybookings
    end
    IO.puts "PARCEL DELIVERY BOOKING LIST IS"
    IO.inspect parceldeliverybooking_list


    parceldeliverybooking = sumList(parceldeliverybooking_list)

    render(conn, "index.html", parceldeliverybooking: parceldeliverybooking)
  end



  def new(conn, parcel_booking_params) do
    IO.puts "booking params in new parcel deliv is "
    IO.inspect parcel_booking_params
    changeset = ParcelBookings.change_parcel_delivery_booking(%ParcelDeliveryBooking{})
    render(conn, "new.html", [changeset: changeset, parcel_booking_params: parcel_booking_params])
  end

  def create(conn, %{"parcel_delivery_booking" => parcel_delivery_booking_params}) do

    travelnotice_id = parcel_delivery_booking_params["travelnotice_id"]
    travelnotice = Mololine.Notices.get_travel_notice!(travelnotice_id)
    parcel_unique_id = parcel_delivery_booking_params["parcel_unique_id"]
    parcel = Mololine.Resources.get_parcel!(parcel_unique_id)
    {booking_id} = make_random_booking_id1()
    parcel_delivery_booking_params = Map.put(parcel_delivery_booking_params, "booking_id",booking_id)
    IO.inspect parcel_delivery_booking_params

    # check  repetition
    if(checkRepetition(String.to_integer(parcel_unique_id))) do
      # there is rep ... stop
      conn
      |> put_flash(:error, "booking failed, There is parcel delivery booking with that parcel ID and hasn't been checked in yet")
      |> redirect(to: Routes.parcel_delivery_booking_path(conn, :index))
      else
      # there is no repetition ... continue
      case ParcelBookings.create_parcel_delivery_booking(parcel_delivery_booking_params,parcel,travelnotice) do
        {:ok, parcel_delivery_booking} ->
          conn
          |> put_flash(:info, "Parcel delivery booking created successfully.")
          |> redirect(to: Routes.parcel_delivery_booking_path(conn, :show, parcel_delivery_booking))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
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
  defp make_random_booking_id1() do
    random_number = :rand.uniform(999999999)
    # find booking with this no
    booking_with_no = Repo.get_by(ParcelDeliveryBooking, booking_id: random_number)
    if(booking_with_no != nil) do
      {
        # call itself
        make_random_booking_id1()
      }
    else
      {
        random_number
      }
    end
    ## we need to make random booking ids for the bookings that will be used in checkins and ticket validations
  end

  defp checkRepetition(parcel_id) do
     # check if there is parcel booking with same parcel ID and hasnt been checked in
     #if so deny creation of parcelboking.
    import Ecto.Query, only: [from: 2]

    # Create a query
    query = from pdb in "parceldeliverybooking",
                 where: pdb.parcel_unique_id == ^parcel_id and pdb.checked_in == false,
                 select: pdb.booking_id

    # Send the query to the repository
    existing  = List.first(Repo.all(query))

    if existing == nil do
      false
      else
      true
    end
  end

  defp sumList([h,t]) do
    h ++ sumList(t)
  end

  defp sumList([pdb]) do
    pdb
  end
  defp sumList(pdb) do
    pdb
  end
end
