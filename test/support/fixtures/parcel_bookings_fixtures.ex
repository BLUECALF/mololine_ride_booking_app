defmodule Mololine.ParcelBookingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.ParcelBookings` context.
  """

  @doc """
  Generate a parcel_delivery_booking.
  """
  def parcel_delivery_booking_fixture(attrs \\ %{}) do
    {:ok, parcel_delivery_booking} =
      attrs
      |> Enum.into(%{
        checked_in: true,
        checked_out: true,
        delivered: true,
        droppoint: "some droppoint",
        parcel_id: "some parcel_id",
        pickuppoint: "some pickuppoint"
      })
      |> Mololine.ParcelBookings.create_parcel_delivery_booking()

    parcel_delivery_booking
  end
end
