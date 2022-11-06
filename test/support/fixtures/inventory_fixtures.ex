defmodule Mololine.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Inventory` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        parcel_booking_id: 42,
        parcel_id: 42,
        town: "some town"
      })
      |> Mololine.Inventory.create_item()

    item
  end
end
