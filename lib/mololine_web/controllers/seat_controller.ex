defmodule MololineWeb.SeatController do
  use MololineWeb, :controller

  alias Mololine.Seats
  alias Mololine.Seats.Seat

  def index(conn, _params) do
    seats = Seats.list_seats()
    render(conn, "index.html", seats: seats)
  end

  def new(conn, _params) do
    changeset = Seats.change_seat(%Seat{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"seat" => seat_params}) do
    case Seats.create_seat(seat_params) do
      {:ok, seat} ->
        conn
        |> put_flash(:info, "Seat created successfully.")
        |> redirect(to: Routes.seat_path(conn, :show, seat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    seat = Seats.get_seat!(id)
    render(conn, "show.html", seat: seat)
  end

  def edit(conn, %{"id" => id}) do
    seat = Seats.get_seat!(id)
    changeset = Seats.change_seat(seat)
    render(conn, "edit.html", seat: seat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "seat" => seat_params}) do
    seat = Seats.get_seat!(id)

    case Seats.update_seat(seat, seat_params) do
      {:ok, seat} ->
        conn
        |> put_flash(:info, "Seat updated successfully.")
        |> redirect(to: Routes.seat_path(conn, :show, seat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", seat: seat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    seat = Seats.get_seat!(id)
    {:ok, _seat} = Seats.delete_seat(seat)

    conn
    |> put_flash(:info, "Seat deleted successfully.")
    |> redirect(to: Routes.seat_path(conn, :index))
  end
end
