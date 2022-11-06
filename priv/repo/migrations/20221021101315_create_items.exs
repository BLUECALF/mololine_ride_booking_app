defmodule Mololine.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :parcel_id, :integer
      add :town, :string
      add :parcel_booking_id, :integer

      timestamps()
    end
  end
end
