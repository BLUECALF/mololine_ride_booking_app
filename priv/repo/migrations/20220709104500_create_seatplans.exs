defmodule Mololine.Repo.Migrations.CreateSeatplans do
  use Ecto.Migration

  def change do
    create table(:seatplans) do
      add :name, :string
      add :seats, {:array, :string}

      timestamps()
    end
  end
end
