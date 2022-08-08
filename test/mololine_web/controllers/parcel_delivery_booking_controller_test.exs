defmodule MololineWeb.ParcelDeliveryBookingControllerTest do
  use MololineWeb.ConnCase

  import Mololine.ParcelBookingsFixtures

  @create_attrs %{checked_in: true, checked_out: true, delivered: true, droppoint: "some droppoint", parcel_id: "some parcel_id", pickuppoint: "some pickuppoint"}
  @update_attrs %{checked_in: false, checked_out: false, delivered: false, droppoint: "some updated droppoint", parcel_id: "some updated parcel_id", pickuppoint: "some updated pickuppoint"}
  @invalid_attrs %{checked_in: nil, checked_out: nil, delivered: nil, droppoint: nil, parcel_id: nil, pickuppoint: nil}

  describe "index" do
    test "lists all parceldeliverybooking", %{conn: conn} do
      conn = get(conn, Routes.parcel_delivery_booking_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Parceldeliverybooking"
    end
  end

  describe "new parcel_delivery_booking" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.parcel_delivery_booking_path(conn, :new))
      assert html_response(conn, 200) =~ "New Parcel delivery booking"
    end
  end

  describe "create parcel_delivery_booking" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parcel_delivery_booking_path(conn, :create), parcel_delivery_booking: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.parcel_delivery_booking_path(conn, :show, id)

      conn = get(conn, Routes.parcel_delivery_booking_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Parcel delivery booking"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parcel_delivery_booking_path(conn, :create), parcel_delivery_booking: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Parcel delivery booking"
    end
  end

  describe "edit parcel_delivery_booking" do
    setup [:create_parcel_delivery_booking]

    test "renders form for editing chosen parcel_delivery_booking", %{conn: conn, parcel_delivery_booking: parcel_delivery_booking} do
      conn = get(conn, Routes.parcel_delivery_booking_path(conn, :edit, parcel_delivery_booking))
      assert html_response(conn, 200) =~ "Edit Parcel delivery booking"
    end
  end

  describe "update parcel_delivery_booking" do
    setup [:create_parcel_delivery_booking]

    test "redirects when data is valid", %{conn: conn, parcel_delivery_booking: parcel_delivery_booking} do
      conn = put(conn, Routes.parcel_delivery_booking_path(conn, :update, parcel_delivery_booking), parcel_delivery_booking: @update_attrs)
      assert redirected_to(conn) == Routes.parcel_delivery_booking_path(conn, :show, parcel_delivery_booking)

      conn = get(conn, Routes.parcel_delivery_booking_path(conn, :show, parcel_delivery_booking))
      assert html_response(conn, 200) =~ "some updated droppoint"
    end

    test "renders errors when data is invalid", %{conn: conn, parcel_delivery_booking: parcel_delivery_booking} do
      conn = put(conn, Routes.parcel_delivery_booking_path(conn, :update, parcel_delivery_booking), parcel_delivery_booking: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Parcel delivery booking"
    end
  end

  describe "delete parcel_delivery_booking" do
    setup [:create_parcel_delivery_booking]

    test "deletes chosen parcel_delivery_booking", %{conn: conn, parcel_delivery_booking: parcel_delivery_booking} do
      conn = delete(conn, Routes.parcel_delivery_booking_path(conn, :delete, parcel_delivery_booking))
      assert redirected_to(conn) == Routes.parcel_delivery_booking_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.parcel_delivery_booking_path(conn, :show, parcel_delivery_booking))
      end
    end
  end

  defp create_parcel_delivery_booking(_) do
    parcel_delivery_booking = parcel_delivery_booking_fixture()
    %{parcel_delivery_booking: parcel_delivery_booking}
  end
end
