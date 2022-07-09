defmodule MololineWeb.SeatControllerTest do
  use MololineWeb.ConnCase

  import Mololine.SeatsFixtures

  @create_attrs %{booked: true, column: 42, row: 42, selected: true}
  @update_attrs %{booked: false, column: 43, row: 43, selected: false}
  @invalid_attrs %{booked: nil, column: nil, row: nil, selected: nil}

  describe "index" do
    test "lists all seats", %{conn: conn} do
      conn = get(conn, Routes.seat_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Seats"
    end
  end

  describe "new seat" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.seat_path(conn, :new))
      assert html_response(conn, 200) =~ "New Seat"
    end
  end

  describe "create seat" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.seat_path(conn, :create), seat: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.seat_path(conn, :show, id)

      conn = get(conn, Routes.seat_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Seat"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.seat_path(conn, :create), seat: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Seat"
    end
  end

  describe "edit seat" do
    setup [:create_seat]

    test "renders form for editing chosen seat", %{conn: conn, seat: seat} do
      conn = get(conn, Routes.seat_path(conn, :edit, seat))
      assert html_response(conn, 200) =~ "Edit Seat"
    end
  end

  describe "update seat" do
    setup [:create_seat]

    test "redirects when data is valid", %{conn: conn, seat: seat} do
      conn = put(conn, Routes.seat_path(conn, :update, seat), seat: @update_attrs)
      assert redirected_to(conn) == Routes.seat_path(conn, :show, seat)

      conn = get(conn, Routes.seat_path(conn, :show, seat))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, seat: seat} do
      conn = put(conn, Routes.seat_path(conn, :update, seat), seat: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Seat"
    end
  end

  describe "delete seat" do
    setup [:create_seat]

    test "deletes chosen seat", %{conn: conn, seat: seat} do
      conn = delete(conn, Routes.seat_path(conn, :delete, seat))
      assert redirected_to(conn) == Routes.seat_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.seat_path(conn, :show, seat))
      end
    end
  end

  defp create_seat(_) do
    seat = seat_fixture()
    %{seat: seat}
  end
end
