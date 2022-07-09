defmodule Mololine.Seatplans do
  @moduledoc """
  The Seatplans context.
  """

  import Ecto.Query, warn: false
  alias Mololine.Repo

  alias Mololine.Seatplans.Seatplan

  @doc """
  Returns the list of seatplans.

  ## Examples

      iex> list_seatplans()
      [%Seatplan{}, ...]

  """
  def list_seatplans do
    Repo.all(Seatplan)
  end

  @doc """
  Gets a single seatplan.

  Raises `Ecto.NoResultsError` if the Seatplan does not exist.

  ## Examples

      iex> get_seatplan!(123)
      %Seatplan{}

      iex> get_seatplan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_seatplan!(id), do: Repo.get!(Seatplan, id)

  @doc """
  Creates a seatplan.

  ## Examples

      iex> create_seatplan(%{field: value})
      {:ok, %Seatplan{}}

      iex> create_seatplan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_seatplan(attrs \\ %{}) do
    %Seatplan{}
    |> Seatplan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a seatplan.

  ## Examples

      iex> update_seatplan(seatplan, %{field: new_value})
      {:ok, %Seatplan{}}

      iex> update_seatplan(seatplan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_seatplan(%Seatplan{} = seatplan, attrs) do
    seatplan
    |> Seatplan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a seatplan.

  ## Examples

      iex> delete_seatplan(seatplan)
      {:ok, %Seatplan{}}

      iex> delete_seatplan(seatplan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_seatplan(%Seatplan{} = seatplan) do
    Repo.delete(seatplan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking seatplan changes.

  ## Examples

      iex> change_seatplan(seatplan)
      %Ecto.Changeset{data: %Seatplan{}}

  """
  def change_seatplan(%Seatplan{} = seatplan, attrs \\ %{}) do
    Seatplan.changeset(seatplan, attrs)
  end
end
