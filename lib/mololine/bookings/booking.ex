defmodule Mololine.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :seat, {:array,:string}
    field :checked_in, :boolean, default: false
    field :booking_id, :integer

    #assosiations
    belongs_to :travelnotice, Mololine.Notices.TravelNotice # this was added
    belongs_to :user, Mololine.Accounts.User # this was added
    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:seat,:booking_id])
    |> validate_required([:seat,:booking_id])
  end
end
