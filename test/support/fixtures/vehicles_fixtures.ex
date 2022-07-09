defmodule Mololine.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Vehicles` context.
  """

  @doc """
  Generate a vehicle.
  """
  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> Enum.into(%{
        plate: "some plate"
      })
      |> Mololine.Vehicles.create_vehicle()

    vehicle
  end
end
