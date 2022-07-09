defmodule MololineWeb.SeatplanControllerTest do
  use MololineWeb.ConnCase

  import Mololine.SeatplansFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all seatplans", %{conn: conn} do
      conn = get(conn, Routes.seatplan_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Seatplans"
    end
  end

  describe "new seatplan" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.seatplan_path(conn, :new))
      assert html_response(conn, 200) =~ "New Seatplan"
    end
  end

  describe "create seatplan" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.seatplan_path(conn, :create), seatplan: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.seatplan_path(conn, :show, id)

      conn = get(conn, Routes.seatplan_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Seatplan"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.seatplan_path(conn, :create), seatplan: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Seatplan"
    end
  end

  describe "edit seatplan" do
    setup [:create_seatplan]

    test "renders form for editing chosen seatplan", %{conn: conn, seatplan: seatplan} do
      conn = get(conn, Routes.seatplan_path(conn, :edit, seatplan))
      assert html_response(conn, 200) =~ "Edit Seatplan"
    end
  end

  describe "update seatplan" do
    setup [:create_seatplan]

    test "redirects when data is valid", %{conn: conn, seatplan: seatplan} do
      conn = put(conn, Routes.seatplan_path(conn, :update, seatplan), seatplan: @update_attrs)
      assert redirected_to(conn) == Routes.seatplan_path(conn, :show, seatplan)

      conn = get(conn, Routes.seatplan_path(conn, :show, seatplan))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, seatplan: seatplan} do
      conn = put(conn, Routes.seatplan_path(conn, :update, seatplan), seatplan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Seatplan"
    end
  end

  describe "delete seatplan" do
    setup [:create_seatplan]

    test "deletes chosen seatplan", %{conn: conn, seatplan: seatplan} do
      conn = delete(conn, Routes.seatplan_path(conn, :delete, seatplan))
      assert redirected_to(conn) == Routes.seatplan_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.seatplan_path(conn, :show, seatplan))
      end
    end
  end

  defp create_seatplan(_) do
    seatplan = seatplan_fixture()
    %{seatplan: seatplan}
  end
end
