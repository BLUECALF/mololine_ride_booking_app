defmodule Mololine.Seatplans.Seatplan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "seatplans" do
    field :name, :string
    has_many :seats, Mololine.Seats.Seat # this was added
    timestamps()
  end

  @doc false
  def changeset(seatplan, attrs) do
    seatplan
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
