defmodule Mololine.TownsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Towns` context.
  """

  @doc """
  Generate a town.
  """
  def town_fixture(attrs \\ %{}) do
    {:ok, town} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Mololine.Towns.create_town()

    town
  end
end
