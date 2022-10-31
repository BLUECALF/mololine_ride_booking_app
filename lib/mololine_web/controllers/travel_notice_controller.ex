defmodule MololineWeb.TravelNoticeController do
  use MololineWeb, :controller

  alias Mololine.Notices
  alias Mololine.Repo
  alias Mololine.Notices.TravelNotice
  alias Mololine.Towns.Town
  alias Mololine.Vehicles.Vehicle
  alias Mololine.Accounts.User

  def index(conn, _params) do
      travelnotices =  Repo.all(TravelNotice)
      render(conn, "index.html", travelnotices: travelnotices)
  end
  def driver(conn, _params) do
    #alias Mololine.Repo
    #alias Mololine.Notices.TravelNotice

    travelnotices = []
    user_id = conn.assigns.current_user.id
    IO.puts("current user id #{user_id}")
   user = Repo.get(User,user_id) |> Repo.preload(:vehicle)
   vehicle = user.vehicle
   if(vehicle == nil) do
      conn
      |> put_flash(:error, "You have no Vehicle ... cannot make Travel notices ")
      |>render("index.html", travelnotices: travelnotices)
      else
      vid = vehicle.id
      vehicle = Repo.get(Vehicle,vid) |> Repo.preload(:travelnotices)
      travelnotices = vehicle.travelnotices
      render(conn, "driver.html", travelnotices: travelnotices)
   end
  end

  def new(conn, _params) do
    changeset = Notices.change_travel_notice(%TravelNotice{})
    towns = Repo.all(Town)
    user = conn.assigns.current_user
    vehicle = Repo.get_by(Vehicle,driveremail: user.email) |>Repo.preload(:driver)
    if(vehicle == nil) do
      conn
      |> put_flash(:error, "You have no Vehicle ... cannot make Travel notices ")
      |>render("index.html", travelnotices: [])
      else
    render(conn, "new.html", [changeset: changeset, towns: towns,vehicle: vehicle])
    end
  end

  def create(conn, %{"travel_notice" => travel_notice_params}) do
    user = conn.assigns.current_user
    vehicle = Repo.get_by(Vehicle,driveremail: user.email)
    if(travel_notice_params["from"] == travel_notice_params["to"]) do
        conn
        |> put_flash(:error, "From location and To location cannot be same")
        |> redirect(to: Routes.travel_notice_path(conn, :new,[]))
      else
      case Notices.create_travel_notice(travel_notice_params,vehicle) do
        {:ok, travel_notice} ->
          conn
          |> put_flash(:info, "Travel notice created successfully.")
          |> redirect(to: Routes.travel_notice_path(conn, :show, travel_notice))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    travel_notice = Notices.get_travel_notice!(id)
    render(conn, "show.html", travel_notice: travel_notice)
  end

  def edit(conn, %{"id" => id}) do
    travel_notice = Notices.get_travel_notice!(id)
    changeset = Notices.change_travel_notice(travel_notice)
    towns = Repo.all(Town)
    render(conn, "edit.html", [travel_notice: travel_notice,towns: towns,changeset: changeset])
  end

  def update(conn, %{"id" => id, "travel_notice" => travel_notice_params}) do
    travel_notice = Notices.get_travel_notice!(id)

    case Notices.update_travel_notice(travel_notice, travel_notice_params) do
      {:ok, travel_notice} ->
        conn
        |> put_flash(:info, "Travel notice updated successfully.")
        |> redirect(to: Routes.travel_notice_path(conn, :show, travel_notice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", travel_notice: travel_notice, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    travel_notice = Notices.get_travel_notice!(id)
    {:ok, _travel_notice} = Notices.delete_travel_notice(travel_notice)

    conn
    |> put_flash(:info, "Travel notice deleted successfully.")
    |> redirect(to: Routes.travel_notice_path(conn, :index))
  end
end
