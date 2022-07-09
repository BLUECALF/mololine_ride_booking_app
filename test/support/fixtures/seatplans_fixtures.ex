defmodule Mololine.SeatplansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Seatplans` context.
  """

  @doc """
  Generate a seatplan.
  """
  def seatplan_fixture(attrs \\ %{}) do
    {:ok, seatplan} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Mololine.Seatplans.create_seatplan()

    seatplan
  end
end
