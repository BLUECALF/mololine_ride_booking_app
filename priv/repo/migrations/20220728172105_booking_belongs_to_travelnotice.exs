defmodule Mololine.Repo.Migrations.BookingBelongsToTravelnotice do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :travelnotice_id, references(:travelnotices)
      add :user_id, references(:users)
    end
  end
end
