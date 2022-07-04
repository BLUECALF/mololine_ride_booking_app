defmodule Mololine.ResourcesTest do
  use Mololine.DataCase

  alias Mololine.Resources

  describe "parcels" do
    alias Mololine.Resources.Parcel

    import Mololine.ResourcesFixtures

    @invalid_attrs %{from: nil, name: nil, to: nil}

    test "list_parcels/0 returns all parcels" do
      parcel = parcel_fixture()
      assert Resources.list_parcels() == [parcel]
    end

    test "get_parcel!/1 returns the parcel with given id" do
      parcel = parcel_fixture()
      assert Resources.get_parcel!(parcel.id) == parcel
    end

    test "create_parcel/1 with valid data creates a parcel" do
      valid_attrs = %{from: "some from", name: "some name", to: "some to"}

      assert {:ok, %Parcel{} = parcel} = Resources.create_parcel(valid_attrs)
      assert parcel.from == "some from"
      assert parcel.name == "some name"
      assert parcel.to == "some to"
    end

    test "create_parcel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_parcel(@invalid_attrs)
    end

    test "update_parcel/2 with valid data updates the parcel" do
      parcel = parcel_fixture()
      update_attrs = %{from: "some updated from", name: "some updated name", to: "some updated to"}

      assert {:ok, %Parcel{} = parcel} = Resources.update_parcel(parcel, update_attrs)
      assert parcel.from == "some updated from"
      assert parcel.name == "some updated name"
      assert parcel.to == "some updated to"
    end

    test "update_parcel/2 with invalid data returns error changeset" do
      parcel = parcel_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_parcel(parcel, @invalid_attrs)
      assert parcel == Resources.get_parcel!(parcel.id)
    end

    test "delete_parcel/1 deletes the parcel" do
      parcel = parcel_fixture()
      assert {:ok, %Parcel{}} = Resources.delete_parcel(parcel)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_parcel!(parcel.id) end
    end

    test "change_parcel/1 returns a parcel changeset" do
      parcel = parcel_fixture()
      assert %Ecto.Changeset{} = Resources.change_parcel(parcel)
    end
  end
end
