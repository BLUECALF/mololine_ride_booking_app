defmodule Mololine.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :seat, {:array, :string}

      timestamps()
    end
  end
end
