defmodule Mololine.Repo.Migrations.CreateParcels do
  use Ecto.Migration

  def change do
    create table(:parcels) do
      add :name, :string
      add :from, :string
      add :to, :string

      timestamps()
    end
  end
end
