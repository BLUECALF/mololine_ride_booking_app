defmodule Mololine.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset
 alias Mololine.Seatplans.Seatplan
  schema "vehicles" do
    field :plate, :string
    field :seatplanname, :string
    has_one :seatplan, Mololine.Seatplans.Seatplan # this was added
    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:plate,:seatplanname])
    |> validate_required([:plate,:seatplanname])
  end
end
