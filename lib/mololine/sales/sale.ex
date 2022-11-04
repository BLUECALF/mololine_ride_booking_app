defmodule Mololine.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field :amount, :integer
    field :date, :date
    field :from, :string
    field :reason, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [:from, :to, :amount, :reason, :date])
    |> validate_required([:from, :to, :amount, :reason, :date])
  end
end
