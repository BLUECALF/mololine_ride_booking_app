defmodule Mololine.SeatsTest do
  use Mololine.DataCase

  alias Mololine.Seats

  describe "seats" do
    alias Mololine.Seats.Seat

    import Mololine.SeatsFixtures

    @invalid_attrs %{booked: nil, column: nil, row: nil, selected: nil}

    test "list_seats/0 returns all seats" do
      seat = seat_fixture()
      assert Seats.list_seats() == [seat]
    end

    test "get_seat!/1 returns the seat with given id" do
      seat = seat_fixture()
      assert Seats.get_seat!(seat.id) == seat
    end

    test "create_seat/1 with valid data creates a seat" do
      valid_attrs = %{booked: true, column: 42, row: 42, selected: true}

      assert {:ok, %Seat{} = seat} = Seats.create_seat(valid_attrs)
      assert seat.booked == true
      assert seat.column == 42
      assert seat.row == 42
      assert seat.selected == true
    end

    test "create_seat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Seats.create_seat(@invalid_attrs)
    end

    test "update_seat/2 with valid data updates the seat" do
      seat = seat_fixture()
      update_attrs = %{booked: false, column: 43, row: 43, selected: false}

      assert {:ok, %Seat{} = seat} = Seats.update_seat(seat, update_attrs)
      assert seat.booked == false
      assert seat.column == 43
      assert seat.row == 43
      assert seat.selected == false
    end

    test "update_seat/2 with invalid data returns error changeset" do
      seat = seat_fixture()
      assert {:error, %Ecto.Changeset{}} = Seats.update_seat(seat, @invalid_attrs)
      assert seat == Seats.get_seat!(seat.id)
    end

    test "delete_seat/1 deletes the seat" do
      seat = seat_fixture()
      assert {:ok, %Seat{}} = Seats.delete_seat(seat)
      assert_raise Ecto.NoResultsError, fn -> Seats.get_seat!(seat.id) end
    end

    test "change_seat/1 returns a seat changeset" do
      seat = seat_fixture()
      assert %Ecto.Changeset{} = Seats.change_seat(seat)
    end
  end
end
