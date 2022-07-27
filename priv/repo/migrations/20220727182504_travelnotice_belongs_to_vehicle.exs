defmodule Mololine.Repo.Migrations.TravelnoticeBelongsToVehicle do
  use Ecto.Migration

  def change do
    alter table(:travelnotices) do
      add :vehicle_id, references(:vehicles)
      add :plate ,:string
    end
  end
end
