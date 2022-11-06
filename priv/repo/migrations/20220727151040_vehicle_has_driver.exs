defmodule Mololine.Repo.Migrations.VehicleHasDriver do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :vehicle_id, references(:vehicles)
      add :town_id, references(:towns)
    end
  end
end
