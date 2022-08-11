defmodule Mololine.Repo.Migrations.CreateParceldeliverybooking do
  use Ecto.Migration

  def change do
    create table(:parceldeliverybooking) do
      add :parcel_unique_id, :integer
      add :pickuppoint, :string
      add :pickuppoint_email, :string
      add :pickuppoint_location, :string
      add :pickuppoint_phone, :string
      add :droppoint, :string
      add :droppoint_email, :string
      add :droppoint_location, :string
      add :droppoint_phone, :string
      add :checked_in, :boolean, default: false, null: false
      add :checked_out, :boolean, default: false, null: false
      add :delivered, :boolean, default: false, null: false

      # associations
      add :travelnotice_id, references(:travelnotices)
      add :parcel_id, references(:parcels)
      timestamps()
    end
  end
end
