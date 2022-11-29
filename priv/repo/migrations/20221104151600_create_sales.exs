defmodule Mololine.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add :from, :string
      add :to, :string
      add :amount, :integer
      add :reason, :string
      add :date, :date

      timestamps()
    end
  end
end
