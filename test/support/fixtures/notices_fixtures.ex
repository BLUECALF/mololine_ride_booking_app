defmodule Mololine.NoticesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Notices` context.
  """

  @doc """
  Generate a travel_notice.
  """
  def travel_notice_fixture(attrs \\ %{}) do
    {:ok, travel_notice} =
      attrs
      |> Enum.into(%{
        from: "some from",
        price: 42,
        to: "some to"
      })
      |> Mololine.Notices.create_travel_notice()

    travel_notice
  end
end
