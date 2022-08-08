defmodule Mololine.Repo.Migrations.CreateParceldeliverybooking do
  use Ecto.Migration

  def change do
    create table(:parceldeliverybooking) do
      add :parcel_unique_id, :integer
      add :pickuppoint, :string
      add :droppoint, :string
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
