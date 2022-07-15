defmodule Mololine.Notices do
  @moduledoc """
  The Notices context.
  """

  import Ecto.Query, warn: false
  alias Mololine.Repo

  alias Mololine.Notices.TravelNotice

  @doc """
  Returns the list of travelnotices.

  ## Examples

      iex> list_travelnotices()
      [%TravelNotice{}, ...]

  """
  def list_travelnotices do
    Repo.all(TravelNotice)
  end

  @doc """
  Gets a single travel_notice.

  Raises `Ecto.NoResultsError` if the Travel notice does not exist.

  ## Examples

      iex> get_travel_notice!(123)
      %TravelNotice{}

      iex> get_travel_notice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_travel_notice!(id), do: Repo.get!(TravelNotice, id)

  @doc """
  Creates a travel_notice.

  ## Examples

      iex> create_travel_notice(%{field: value})
      {:ok, %TravelNotice{}}

      iex> create_travel_notice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_travel_notice(attrs \\ %{}) do
    %TravelNotice{}
    |> TravelNotice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a travel_notice.

  ## Examples

      iex> update_travel_notice(travel_notice, %{field: new_value})
      {:ok, %TravelNotice{}}

      iex> update_travel_notice(travel_notice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_travel_notice(%TravelNotice{} = travel_notice, attrs) do
    travel_notice
    |> TravelNotice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a travel_notice.

  ## Examples

      iex> delete_travel_notice(travel_notice)
      {:ok, %TravelNotice{}}

      iex> delete_travel_notice(travel_notice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_travel_notice(%TravelNotice{} = travel_notice) do
    Repo.delete(travel_notice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking travel_notice changes.

  ## Examples

      iex> change_travel_notice(travel_notice)
      %Ecto.Changeset{data: %TravelNotice{}}

  """
  def change_travel_notice(%TravelNotice{} = travel_notice, attrs \\ %{}) do
    TravelNotice.changeset(travel_notice, attrs)
  end
end
