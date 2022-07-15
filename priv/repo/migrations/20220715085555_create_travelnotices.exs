defmodule Mololine.Repo.Migrations.CreateTravelnotices do
  use Ecto.Migration

  def change do
    create table(:travelnotices) do
      add :to, :string
      add :from, :string
      add :price, :integer
      add :date, :date
      add :time, :time

      timestamps()
    end
  end
end
