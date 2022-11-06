defmodule Mololine.ParcelBookings.ParcelDeliveryBooking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parceldeliverybooking" do
    field :checked_in, :boolean, default: false
    field :checked_out, :boolean, default: false
    field :delivered, :boolean, default: false
    field :droppoint, :string
    field :droppoint_email, :string
    field :droppoint_location, :string
    field :droppoint_phone, :string
    field :parcel_unique_id, :integer
    field :pickuppoint, :string
    field :pickuppoint_email, :string
    field :pickuppoint_location, :string
    field :pickuppoint_phone, :string
    field :booking_id, :integer

    #assosiations
    belongs_to :travelnotice, Mololine.Notices.TravelNotice # this was added
    belongs_to :parcel, Mololine.Resources.Parcel # this was added
    timestamps()
  end

  @doc false
  def changeset(parcel_delivery_booking, attrs) do
    parcel_delivery_booking
    |> cast(attrs, [:parcel_unique_id,
      :pickuppoint,
      :pickuppoint_email,
      :pickuppoint_location,
      :pickuppoint_phone,
      :droppoint,
      :droppoint_email,
      :droppoint_location,
      :droppoint_phone,
      :checked_in,
      :checked_out,
      :delivered,
      :booking_id])
    |> validate_required([:parcel_unique_id, :pickuppoint, :droppoint])
  end
end
