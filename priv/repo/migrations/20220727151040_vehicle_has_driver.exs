defmodule Mololine.Repo.Migrations.VehicleHasDriver do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :vehicle_id, references(:vehicles)
    end
  end
end
