defmodule Mololine.Repo.Migrations.CreateParcels do
  use Ecto.Migration

  def change do
    create table(:parcels) do
      add :recipient_name, :string
      add :recipient_phone, :string
      add :weight, :integer
      add :pin, :string

      timestamps()
    end
  end
end
