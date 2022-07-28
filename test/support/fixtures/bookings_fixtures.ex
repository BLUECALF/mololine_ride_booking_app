defmodule Mololine.BookingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Bookings` context.
  """

  @doc """
  Generate a booking.
  """
  def booking_fixture(attrs \\ %{}) do
    {:ok, booking} =
      attrs
      |> Enum.into(%{
        seat: "some seat"
      })
      |> Mololine.Bookings.create_booking()

    booking
  end
end
