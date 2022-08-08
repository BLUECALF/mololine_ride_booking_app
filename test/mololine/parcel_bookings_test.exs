defmodule Mololine.ParcelBookingsTest do
  use Mololine.DataCase

  alias Mololine.ParcelBookings

  describe "parceldeliverybooking" do
    alias Mololine.ParcelBookings.ParcelDeliveryBooking

    import Mololine.ParcelBookingsFixtures

    @invalid_attrs %{checked_in: nil, checked_out: nil, delivered: nil, droppoint: nil, parcel_id: nil, pickuppoint: nil}

    test "list_parceldeliverybooking/0 returns all parceldeliverybooking" do
      parcel_delivery_booking = parcel_delivery_booking_fixture()
      assert ParcelBookings.list_parceldeliverybooking() == [parcel_delivery_booking]
    end

    test "get_parcel_delivery_booking!/1 returns the parcel_delivery_booking with given id" do
      parcel_delivery_booking = parcel_delivery_booking_fixture()
      assert ParcelBookings.get_parcel_delivery_booking!(parcel_delivery_booking.id) == parcel_delivery_booking
    end

    test "create_parcel_delivery_booking/1 with valid data creates a parcel_delivery_booking" do
      valid_attrs = %{checked_in: true, checked_out: true, delivered: true, droppoint: "some droppoint", parcel_id: "some parcel_id", pickuppoint: "some pickuppoint"}

      assert {:ok, %ParcelDeliveryBooking{} = parcel_delivery_booking} = ParcelBookings.create_parcel_delivery_booking(valid_attrs)
      assert parcel_delivery_booking.checked_in == true
      assert parcel_delivery_booking.checked_out == true
      assert parcel_delivery_booking.delivered == true
      assert parcel_delivery_booking.droppoint == "some droppoint"
      assert parcel_delivery_booking.parcel_id == "some parcel_id"
      assert parcel_delivery_booking.pickuppoint == "some pickuppoint"
    end

    test "create_parcel_delivery_booking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ParcelBookings.create_parcel_delivery_booking(@invalid_attrs)
    end

    test "update_parcel_delivery_booking/2 with valid data updates the parcel_delivery_booking" do
      parcel_delivery_booking = parcel_delivery_booking_fixture()
      update_attrs = %{checked_in: false, checked_out: false, delivered: false, droppoint: "some updated droppoint", parcel_id: "some updated parcel_id", pickuppoint: "some updated pickuppoint"}

      assert {:ok, %ParcelDeliveryBooking{} = parcel_delivery_booking} = ParcelBookings.update_parcel_delivery_booking(parcel_delivery_booking, update_attrs)
      assert parcel_delivery_booking.checked_in == false
      assert parcel_delivery_booking.checked_out == false
      assert parcel_delivery_booking.delivered == false
      assert parcel_delivery_booking.droppoint == "some updated droppoint"
      assert parcel_delivery_booking.parcel_id == "some updated parcel_id"
      assert parcel_delivery_booking.pickuppoint == "some updated pickuppoint"
    end

    test "update_parcel_delivery_booking/2 with invalid data returns error changeset" do
      parcel_delivery_booking = parcel_delivery_booking_fixture()
      assert {:error, %Ecto.Changeset{}} = ParcelBookings.update_parcel_delivery_booking(parcel_delivery_booking, @invalid_attrs)
      assert parcel_delivery_booking == ParcelBookings.get_parcel_delivery_booking!(parcel_delivery_booking.id)
    end

    test "delete_parcel_delivery_booking/1 deletes the parcel_delivery_booking" do
      parcel_delivery_booking = parcel_delivery_booking_fixture()
      assert {:ok, %ParcelDeliveryBooking{}} = ParcelBookings.delete_parcel_delivery_booking(parcel_delivery_booking)
      assert_raise Ecto.NoResultsError, fn -> ParcelBookings.get_parcel_delivery_booking!(parcel_delivery_booking.id) end
    end

    test "change_parcel_delivery_booking/1 returns a parcel_delivery_booking changeset" do
      parcel_delivery_booking = parcel_delivery_booking_fixture()
      assert %Ecto.Changeset{} = ParcelBookings.change_parcel_delivery_booking(parcel_delivery_booking)
    end
  end
end
