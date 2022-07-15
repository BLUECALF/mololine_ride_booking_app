defmodule Mololine.Towns do
  @moduledoc """
  The Towns context.
  """

  import Ecto.Query, warn: false
  alias Mololine.Repo

  alias Mololine.Towns.Town

  @doc """
  Returns the list of towns.

  ## Examples

      iex> list_towns()
      [%Town{}, ...]

  """
  def list_towns do
    Repo.all(Town)
  end

  @doc """
  Gets a single town.

  Raises `Ecto.NoResultsError` if the Town does not exist.

  ## Examples

      iex> get_town!(123)
      %Town{}

      iex> get_town!(456)
      ** (Ecto.NoResultsError)

  """
  def get_town!(id), do: Repo.get!(Town, id)

  @doc """
  Creates a town.

  ## Examples

      iex> create_town(%{field: value})
      {:ok, %Town{}}

      iex> create_town(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_town(attrs \\ %{}) do
    %Town{}
    |> Town.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a town.

  ## Examples

      iex> update_town(town, %{field: new_value})
      {:ok, %Town{}}

      iex> update_town(town, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_town(%Town{} = town, attrs) do
    town
    |> Town.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a town.

  ## Examples

      iex> delete_town(town)
      {:ok, %Town{}}

      iex> delete_town(town)
      {:error, %Ecto.Changeset{}}

  """
  def delete_town(%Town{} = town) do
    Repo.delete(town)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking town changes.

  ## Examples

      iex> change_town(town)
      %Ecto.Changeset{data: %Town{}}

  """
  def change_town(%Town{} = town, attrs \\ %{}) do
    Town.changeset(town, attrs)
  end
end
