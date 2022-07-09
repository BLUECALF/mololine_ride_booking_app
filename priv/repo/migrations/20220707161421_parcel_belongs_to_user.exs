defmodule Mololine.Repo.Migrations.ParcelBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:parcels) do
      add :user_id, references(:users)
    end
  end
end
