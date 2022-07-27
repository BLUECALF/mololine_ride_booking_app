defmodule MololineWeb.TravelNoticeController do
  use MololineWeb, :controller

  alias Mololine.Notices
  alias Mololine.Repo
  alias Mololine.Notices.TravelNotice
  alias Mololine.Towns.Town
  alias Mololine.Vehicles.Vehicle

  def index(conn, _params) do
    travelnotices = Notices.list_travelnotices()
    render(conn, "index.html", travelnotices: travelnotices)
  end

  def new(conn, _params) do
    changeset = Notices.change_travel_notice(%TravelNotice{})
    towns = Repo.all(Town)
    user = conn.assigns.current_user
    vehicle = Repo.get_by(Vehicle,driveremail: user.email) |>Repo.preload(:driver)
    render(conn, "new.html", [changeset: changeset, towns: towns,vehicle: vehicle])
  end

  def create(conn, %{"travel_notice" => travel_notice_params}) do
    user = conn.assigns.current_user
    vehicle = Repo.get_by(Vehicle,driveremail: user.email)
    case Notices.create_travel_notice(travel_notice_params,vehicle) do
      {:ok, travel_notice} ->
        conn
        |> put_flash(:info, "Travel notice created successfully.")
        |> redirect(to: Routes.travel_notice_path(conn, :show, travel_notice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
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
