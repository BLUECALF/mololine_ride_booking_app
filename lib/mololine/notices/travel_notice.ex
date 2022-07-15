defmodule Mololine.Notices.TravelNotice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "travelnotices" do
    field :from, :string
    field :price, :integer
    field :to, :string
    field :date, :date
    field :time, :time

    timestamps()
  end

  @doc false
  def changeset(travel_notice, attrs) do
    travel_notice
    |> cast(attrs, [:to, :from, :price, :date, :time])
    |> validate_required([:to, :from, :price,:date,:time])
  end
end
