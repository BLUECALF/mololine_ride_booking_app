defmodule Mololine.Resources.Parcel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parcels" do
    field :from, :string
    field :name, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def changeset(parcel, attrs) do
    parcel
    |> cast(attrs, [:name, :from, :to])
    |> validate_required([:name, :from, :to])
  end
end
