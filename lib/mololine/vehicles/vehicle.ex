defmodule Mololine.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset
 alias Mololine.Seatplans.Seatplan
 alias Mololine.Accounts.User
  schema "vehicles" do
    field :plate, :string
    field :seatplanname, :string
    field :driveremail, :string

    # associations
    has_one :seatplan, Mololine.Seatplans.Seatplan # this was added
    has_one :driver, Mololine.Accounts.User# this was added
    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:plate,:seatplanname,:driveremail])
    |> validate_required([:plate,:seatplanname,:driveremail])
    |> unsafe_validate_unique(:plate, Mololine.Repo)
  end
end
