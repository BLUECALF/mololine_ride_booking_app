defmodule Mololine.TownsTest do
  use Mololine.DataCase

  alias Mololine.Towns

  describe "towns" do
    alias Mololine.Towns.Town

    import Mololine.TownsFixtures

    @invalid_attrs %{name: nil}

    test "list_towns/0 returns all towns" do
      town = town_fixture()
      assert Towns.list_towns() == [town]
    end

    test "get_town!/1 returns the town with given id" do
      town = town_fixture()
      assert Towns.get_town!(town.id) == town
    end

    test "create_town/1 with valid data creates a town" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Town{} = town} = Towns.create_town(valid_attrs)
      assert town.name == "some name"
    end

    test "create_town/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Towns.create_town(@invalid_attrs)
    end

    test "update_town/2 with valid data updates the town" do
      town = town_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Town{} = town} = Towns.update_town(town, update_attrs)
      assert town.name == "some updated name"
    end

    test "update_town/2 with invalid data returns error changeset" do
      town = town_fixture()
      assert {:error, %Ecto.Changeset{}} = Towns.update_town(town, @invalid_attrs)
      assert town == Towns.get_town!(town.id)
    end

    test "delete_town/1 deletes the town" do
      town = town_fixture()
      assert {:ok, %Town{}} = Towns.delete_town(town)
      assert_raise Ecto.NoResultsError, fn -> Towns.get_town!(town.id) end
    end

    test "change_town/1 returns a town changeset" do
      town = town_fixture()
      assert %Ecto.Changeset{} = Towns.change_town(town)
    end
  end
end
