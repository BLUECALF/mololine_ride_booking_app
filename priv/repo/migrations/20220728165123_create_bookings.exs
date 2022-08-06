defmodule Mololine.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :seat, {:array, :string}
      add :checked_in, :boolean
      add :booking_id, :integer
      add :total_price, :integer

      timestamps()
    end
  end
end
