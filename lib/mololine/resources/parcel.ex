defmodule Mololine.Resources.Parcel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parcels" do
    field :recipient_name, :string
    field :recipient_phone, :string
    field :weight, :integer
    field :pin, :string

    #associations
    belongs_to :user, Mololine.Accounts.User  # this was added
     #has childresn
    has_many :parceldeliverybookings, Mololine.ParcelBookings.ParcelDeliveryBooking
    timestamps()
  end

  @doc false
  def changeset(parcel, attrs) do
    parcel
    |> cast(attrs, [:recipient_name,:recipient_phone, :weight, :pin])
    |> validate_required([:recipient_name,:recipient_phone, :weight, :pin])
  end
end
