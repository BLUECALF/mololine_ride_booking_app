defmodule Mololine.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset
  schema "vehicles" do
    field :plate, :string
    field :seatplanname, :string
    field :driveremail, :string

    # associations
    has_one :seatplan, Mololine.Seatplans.Seatplan # this was added
    has_one :driver, Mololine.Accounts.User# this was added
    has_many :travelnotices, Mololine.Notices.TravelNotice # this was added
    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:plate,:seatplanname,:driveremail])
    |> validate_required([:plate,:seatplanname,:driveremail])
    |> unsafe_validate_unique(:plate, Mololine.Repo)
    |> validate_length(:plate, max: 8,min: 8)
  end
end
