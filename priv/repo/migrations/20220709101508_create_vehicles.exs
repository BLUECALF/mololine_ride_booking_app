defmodule Mololine.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :plate, :string
      add :seatplanname, :string

      timestamps()
    end
  end
end
