defmodule Mololine.Seats.Seat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "seats" do
    field :booked, :boolean, default: false
    field :column, :integer
    field :row, :integer
    field :selected, :boolean, default: false
    belongs_to :seatplan, Mololine.Seatplans.Seatplan  # this was added
    timestamps()
  end

  @doc false
  def changeset(seat, attrs) do
    seat
    |> cast(attrs, [:column, :row, :booked, :selected])
    |> validate_required([:column, :row, :booked, :selected])
  end
end
