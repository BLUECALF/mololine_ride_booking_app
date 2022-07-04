defmodule Mololine.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Resources` context.
  """

  @doc """
  Generate a parcel.
  """
  def parcel_fixture(attrs \\ %{}) do
    {:ok, parcel} =
      attrs
      |> Enum.into(%{
        from: "some from",
        name: "some name",
        to: "some to"
      })
      |> Mololine.Resources.create_parcel()

    parcel
  end
end
