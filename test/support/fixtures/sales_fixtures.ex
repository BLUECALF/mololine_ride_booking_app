defmodule Mololine.SalesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mololine.Sales` context.
  """

  @doc """
  Generate a sale.
  """
  def sale_fixture(attrs \\ %{}) do
    {:ok, sale} =
      attrs
      |> Enum.into(%{
        amount: 42,
        date: ~D[2022-11-03],
        from: "some from",
        reason: "some reason",
        to: "some to"
      })
      |> Mololine.Sales.create_sale()

    sale
  end
end
