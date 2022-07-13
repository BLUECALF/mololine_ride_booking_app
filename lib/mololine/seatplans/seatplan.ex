defmodule Mololine.Seatplans.Seatplan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "seatplans" do
    field :name, :string
    field :seats, {:array,:string}

    timestamps()
  end

  @doc false
  def changeset(seatplan, attrs) do
    seatplan
    |> cast(attrs, [:name,:seats])
    |> validate_required([:name,:seats])
  end
end
