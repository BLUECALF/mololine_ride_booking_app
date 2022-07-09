defmodule Mololine.Repo.Migrations.SeatplanHasManySeats do
  use Ecto.Migration

  def change do
    alter table(:seatplans) do
      add :seat_id, references(:seats)
    end
  end
end
