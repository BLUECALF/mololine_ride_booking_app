defmodule Mololine.NoticesTest do
  use Mololine.DataCase

  alias Mololine.Notices

  describe "travelnotices" do
    alias Mololine.Notices.TravelNotice

    import Mololine.NoticesFixtures

    @invalid_attrs %{from: nil, price: nil, to: nil}

    test "list_travelnotices/0 returns all travelnotices" do
      travel_notice = travel_notice_fixture()
      assert Notices.list_travelnotices() == [travel_notice]
    end

    test "get_travel_notice!/1 returns the travel_notice with given id" do
      travel_notice = travel_notice_fixture()
      assert Notices.get_travel_notice!(travel_notice.id) == travel_notice
    end

    test "create_travel_notice/1 with valid data creates a travel_notice" do
      valid_attrs = %{from: "some from", price: 42, to: "some to"}

      assert {:ok, %TravelNotice{} = travel_notice} = Notices.create_travel_notice(valid_attrs)
      assert travel_notice.from == "some from"
      assert travel_notice.price == 42
      assert travel_notice.to == "some to"
    end

    test "create_travel_notice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notices.create_travel_notice(@invalid_attrs)
    end

    test "update_travel_notice/2 with valid data updates the travel_notice" do
      travel_notice = travel_notice_fixture()
      update_attrs = %{from: "some updated from", price: 43, to: "some updated to"}

      assert {:ok, %TravelNotice{} = travel_notice} = Notices.update_travel_notice(travel_notice, update_attrs)
      assert travel_notice.from == "some updated from"
      assert travel_notice.price == 43
      assert travel_notice.to == "some updated to"
    end

    test "update_travel_notice/2 with invalid data returns error changeset" do
      travel_notice = travel_notice_fixture()
      assert {:error, %Ecto.Changeset{}} = Notices.update_travel_notice(travel_notice, @invalid_attrs)
      assert travel_notice == Notices.get_travel_notice!(travel_notice.id)
    end

    test "delete_travel_notice/1 deletes the travel_notice" do
      travel_notice = travel_notice_fixture()
      assert {:ok, %TravelNotice{}} = Notices.delete_travel_notice(travel_notice)
      assert_raise Ecto.NoResultsError, fn -> Notices.get_travel_notice!(travel_notice.id) end
    end

    test "change_travel_notice/1 returns a travel_notice changeset" do
      travel_notice = travel_notice_fixture()
      assert %Ecto.Changeset{} = Notices.change_travel_notice(travel_notice)
    end
  end
end
