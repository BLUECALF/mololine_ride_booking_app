defmodule Mololine.Repo.Migrations.CreateTowns do
  use Ecto.Migration

  def change do
    create table(:towns) do
      add :name, :string

      timestamps()
    end
  end
end
