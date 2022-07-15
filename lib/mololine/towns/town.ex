defmodule Mololine.Towns.Town do
  use Ecto.Schema
  import Ecto.Changeset

  schema "towns" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(town, attrs) do
    town
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
