defmodule Mololine.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :plate, :string

    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:plate])
    |> validate_required([:plate])
  end
end
