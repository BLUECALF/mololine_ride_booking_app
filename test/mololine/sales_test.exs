defmodule Mololine.SalesTest do
  use Mololine.DataCase

  alias Mololine.Sales

  describe "sales" do
    alias Mololine.Sales.Sale

    import Mololine.SalesFixtures

    @invalid_attrs %{amount: nil, date: nil, from: nil, reason: nil, to: nil}

    test "list_sales/0 returns all sales" do
      sale = sale_fixture()
      assert Sales.list_sales() == [sale]
    end

    test "get_sale!/1 returns the sale with given id" do
      sale = sale_fixture()
      assert Sales.get_sale!(sale.id) == sale
    end

    test "create_sale/1 with valid data creates a sale" do
      valid_attrs = %{amount: 42, date: ~D[2022-11-03], from: "some from", reason: "some reason", to: "some to"}

      assert {:ok, %Sale{} = sale} = Sales.create_sale(valid_attrs)
      assert sale.amount == 42
      assert sale.date == ~D[2022-11-03]
      assert sale.from == "some from"
      assert sale.reason == "some reason"
      assert sale.to == "some to"
    end

    test "create_sale/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_sale(@invalid_attrs)
    end

    test "update_sale/2 with valid data updates the sale" do
      sale = sale_fixture()
      update_attrs = %{amount: 43, date: ~D[2022-11-04], from: "some updated from", reason: "some updated reason", to: "some updated to"}

      assert {:ok, %Sale{} = sale} = Sales.update_sale(sale, update_attrs)
      assert sale.amount == 43
      assert sale.date == ~D[2022-11-04]
      assert sale.from == "some updated from"
      assert sale.reason == "some updated reason"
      assert sale.to == "some updated to"
    end

    test "update_sale/2 with invalid data returns error changeset" do
      sale = sale_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_sale(sale, @invalid_attrs)
      assert sale == Sales.get_sale!(sale.id)
    end

    test "delete_sale/1 deletes the sale" do
      sale = sale_fixture()
      assert {:ok, %Sale{}} = Sales.delete_sale(sale)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_sale!(sale.id) end
    end

    test "change_sale/1 returns a sale changeset" do
      sale = sale_fixture()
      assert %Ecto.Changeset{} = Sales.change_sale(sale)
    end
  end
end
