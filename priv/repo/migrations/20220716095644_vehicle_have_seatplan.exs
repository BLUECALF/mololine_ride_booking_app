defmodule Mololine.Repo.Migrations.VehicleHaveSeatplan do
  use Ecto.Migration

  def change do
    alter table(:seatplans) do
      add :vehicle_id, references(:vehicles)
    end
  end
end
