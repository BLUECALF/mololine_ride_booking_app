defmodule Mololine.SeatplansTest do
  use Mololine.DataCase

  alias Mololine.Seatplans

  describe "seatplans" do
    alias Mololine.Seatplans.Seatplan

    import Mololine.SeatplansFixtures

    @invalid_attrs %{name: nil}

    test "list_seatplans/0 returns all seatplans" do
      seatplan = seatplan_fixture()
      assert Seatplans.list_seatplans() == [seatplan]
    end

    test "get_seatplan!/1 returns the seatplan with given id" do
      seatplan = seatplan_fixture()
      assert Seatplans.get_seatplan!(seatplan.id) == seatplan
    end

    test "create_seatplan/1 with valid data creates a seatplan" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Seatplan{} = seatplan} = Seatplans.create_seatplan(valid_attrs)
      assert seatplan.name == "some name"
    end

    test "create_seatplan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Seatplans.create_seatplan(@invalid_attrs)
    end

    test "update_seatplan/2 with valid data updates the seatplan" do
      seatplan = seatplan_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Seatplan{} = seatplan} = Seatplans.update_seatplan(seatplan, update_attrs)
      assert seatplan.name == "some updated name"
    end

    test "update_seatplan/2 with invalid data returns error changeset" do
      seatplan = seatplan_fixture()
      assert {:error, %Ecto.Changeset{}} = Seatplans.update_seatplan(seatplan, @invalid_attrs)
      assert seatplan == Seatplans.get_seatplan!(seatplan.id)
    end

    test "delete_seatplan/1 deletes the seatplan" do
      seatplan = seatplan_fixture()
      assert {:ok, %Seatplan{}} = Seatplans.delete_seatplan(seatplan)
      assert_raise Ecto.NoResultsError, fn -> Seatplans.get_seatplan!(seatplan.id) end
    end

    test "change_seatplan/1 returns a seatplan changeset" do
      seatplan = seatplan_fixture()
      assert %Ecto.Changeset{} = Seatplans.change_seatplan(seatplan)
    end
  end
end
