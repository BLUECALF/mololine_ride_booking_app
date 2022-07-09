defmodule Mololine.Repo.Migrations.CreateSeats do
  use Ecto.Migration

  def change do
    create table(:seats) do
      add :column, :integer
      add :row, :integer
      add :booked, :boolean, default: false, null: false
      add :selected, :boolean, default: false, null: false

      timestamps()
    end
  end
end
