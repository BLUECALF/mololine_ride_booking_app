defmodule MololineWeb.SeatplanController do
  use MololineWeb, :controller

  alias Mololine.Seatplans
  alias Mololine.Seatplans.Seatplan

  def index(conn, _params) do
    seatplans = Seatplans.list_seatplans()
    render(conn, "index.html", seatplans: seatplans)
  end

  def new(conn, _params) do
    changeset = Seatplans.change_seatplan(%Seatplan{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"seatplan" => seatplan_params}) do
    case Seatplans.create_seatplan(seatplan_params) do
      {:ok, seatplan} ->
        conn
        |> put_flash(:info, "Seatplan created successfully.")
        |> redirect(to: Routes.seatplan_path(conn, :show, seatplan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    seatplan = Seatplans.get_seatplan!(id)
    render(conn, "show.html", seatplan: seatplan)
  end

  def edit(conn, %{"id" => id}) do
    seatplan = Seatplans.get_seatplan!(id)
    changeset = Seatplans.change_seatplan(seatplan)
    render(conn, "edit.html", seatplan: seatplan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "seatplan" => seatplan_params}) do
    seatplan = Seatplans.get_seatplan!(id)

    case Seatplans.update_seatplan(seatplan, seatplan_params) do
      {:ok, seatplan} ->
        conn
        |> put_flash(:info, "Seatplan updated successfully.")
        |> redirect(to: Routes.seatplan_path(conn, :show, seatplan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", seatplan: seatplan, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    seatplan = Seatplans.get_seatplan!(id)
    {:ok, _seatplan} = Seatplans.delete_seatplan(seatplan)

    conn
    |> put_flash(:info, "Seatplan deleted successfully.")
    |> redirect(to: Routes.seatplan_path(conn, :index))
  end
end
