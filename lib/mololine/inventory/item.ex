defmodule Mololine.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :parcel_booking_id, :integer
    field :parcel_id, :integer
    field :town, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:parcel_id, :town, :parcel_booking_id])
    |> validate_required([:parcel_id, :town, :parcel_booking_id])
  end
end
