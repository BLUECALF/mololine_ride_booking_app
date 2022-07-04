defmodule MololineWeb.ParcelControllerTest do
  use MololineWeb.ConnCase

  import Mololine.ResourcesFixtures

  @create_attrs %{from: "some from", name: "some name", to: "some to"}
  @update_attrs %{from: "some updated from", name: "some updated name", to: "some updated to"}
  @invalid_attrs %{from: nil, name: nil, to: nil}

  describe "index" do
    test "lists all parcels", %{conn: conn} do
      conn = get(conn, Routes.parcel_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Parcels"
    end
  end

  describe "new parcel" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.parcel_path(conn, :new))
      assert html_response(conn, 200) =~ "New Parcel"
    end
  end

  describe "create parcel" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parcel_path(conn, :create), parcel: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.parcel_path(conn, :show, id)

      conn = get(conn, Routes.parcel_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Parcel"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parcel_path(conn, :create), parcel: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Parcel"
    end
  end

  describe "edit parcel" do
    setup [:create_parcel]

    test "renders form for editing chosen parcel", %{conn: conn, parcel: parcel} do
      conn = get(conn, Routes.parcel_path(conn, :edit, parcel))
      assert html_response(conn, 200) =~ "Edit Parcel"
    end
  end

  describe "update parcel" do
    setup [:create_parcel]

    test "redirects when data is valid", %{conn: conn, parcel: parcel} do
      conn = put(conn, Routes.parcel_path(conn, :update, parcel), parcel: @update_attrs)
      assert redirected_to(conn) == Routes.parcel_path(conn, :show, parcel)

      conn = get(conn, Routes.parcel_path(conn, :show, parcel))
      assert html_response(conn, 200) =~ "some updated from"
    end

    test "renders errors when data is invalid", %{conn: conn, parcel: parcel} do
      conn = put(conn, Routes.parcel_path(conn, :update, parcel), parcel: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Parcel"
    end
  end

  describe "delete parcel" do
    setup [:create_parcel]

    test "deletes chosen parcel", %{conn: conn, parcel: parcel} do
      conn = delete(conn, Routes.parcel_path(conn, :delete, parcel))
      assert redirected_to(conn) == Routes.parcel_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.parcel_path(conn, :show, parcel))
      end
    end
  end

  defp create_parcel(_) do
    parcel = parcel_fixture()
    %{parcel: parcel}
  end
end
