defmodule Mololine.ParcelBookings.ParcelDeliveryBooking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parceldeliverybooking" do
    field :checked_in, :boolean, default: false
    field :checked_out, :boolean, default: false
    field :delivered, :boolean, default: false
    field :droppoint, :string
    field :parcel_unique_id, :integer
    field :pickuppoint, :string

    #assosiations
    belongs_to :travelnotice, Mololine.Notices.TravelNotice # this was added
    belongs_to :parcel, Mololine.Resources.Parcel # this was added
    timestamps()
  end

  @doc false
  def changeset(parcel_delivery_booking, attrs) do
    parcel_delivery_booking
    |> cast(attrs, [:parcel_unique_id, :pickuppoint, :droppoint, :checked_in, :checked_out, :delivered])
    |> validate_required([:parcel_unique_id, :pickuppoint, :droppoint])
  end
end
