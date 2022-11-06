defmodule Mololine.InventoryTest do
  use Mololine.DataCase

  alias Mololine.Inventory

  describe "items" do
    alias Mololine.Inventory.Item

    import Mololine.InventoryFixtures

    @invalid_attrs %{parcel_booking_id: nil, parcel_id: nil, town: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Inventory.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Inventory.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{parcel_booking_id: 42, parcel_id: 42, town: "some town"}

      assert {:ok, %Item{} = item} = Inventory.create_item(valid_attrs)
      assert item.parcel_booking_id == 42
      assert item.parcel_id == 42
      assert item.town == "some town"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{parcel_booking_id: 43, parcel_id: 43, town: "some updated town"}

      assert {:ok, %Item{} = item} = Inventory.update_item(item, update_attrs)
      assert item.parcel_booking_id == 43
      assert item.parcel_id == 43
      assert item.town == "some updated town"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_item(item, @invalid_attrs)
      assert item == Inventory.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Inventory.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Inventory.change_item(item)
    end
  end
end
