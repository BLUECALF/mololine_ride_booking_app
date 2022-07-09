defmodule Mololine.SeatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Seats` context.
  """

  @doc """
  Generate a seat.
  """
  def seat_fixture(attrs \\ %{}) do
    {:ok, seat} =
      attrs
      |> Enum.into(%{
        booked: true,
        column: 42,
        row: 42,
        selected: true
      })
      |> Mololine.Seats.create_seat()

    seat
  end
end
