defmodule Mololine.Notices.TravelNotice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "travelnotices" do

    field :plate, :string
    field :from, :string
    field :price, :integer
    field :to, :string
    field :date, :date
    field :time, :time

    # associations
    belongs_to :vehicle, Mololine.Vehicles.Vehicle # this was added

   #travel notice has many bookings and many parceldeliverybookings.
    has_many :bookings, Mololine.Bookings.Booking # this was added
    has_many :parceldeliverybookings, Mololine.ParcelBookings.ParcelDeliveryBooking # this was added

    timestamps()
  end

  @doc false
  def changeset(travel_notice, attrs) do
    travel_notice
    |> cast(attrs, [:to, :from, :price, :date, :time,:plate])
    |> validate_required([:to, :from, :price,:date,:time,:plate])

  end

end
