defmodule Mololine.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Mololine.Repo

  alias Mololine.Resources.Parcel
  alias Mololine.Accounts.User

  defdelegate authorize(action, user, params), to: Mololine.Resources.Policy

  @doc """
  Returns the list of parcels.

  ## Examples

      iex> list_parcels()
      [%Parcel{}, ...]

  """
  def list_parcels do
    Repo.all(Parcel)
  end

  @doc """
  Gets a single parcel.

  Raises `Ecto.NoResultsError` if the Parcel does not exist.

  ## Examples

      iex> get_parcel!(123)
      %Parcel{}

      iex> get_parcel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parcel!(id), do: Repo.get!(Parcel, id)

  @doc """
  Creates a parcel.

  ## Examples

      iex> create_parcel(%{field: value})
      {:ok, %Parcel{}}

      iex> create_parcel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parcel(attrs \\ %{}) do
    %Parcel{}
    |> Parcel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a parcel.

  ## Examples

      iex> update_parcel(parcel, %{field: new_value})
      {:ok, %Parcel{}}

      iex> update_parcel(parcel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parcel(%Parcel{} = parcel, attrs) do
    parcel
    |> Parcel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a parcel.

  ## Examples

      iex> delete_parcel(parcel)
      {:ok, %Parcel{}}

      iex> delete_parcel(parcel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parcel(%Parcel{} = parcel, %User{} = user) do
    with :ok <- Bodyguard.permit(Mololine.Resources, :delete_parcel, user, parcel) do
      Repo.delete(parcel)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parcel changes.

  ## Examples

      iex> change_parcel(parcel)
      %Ecto.Changeset{data: %Parcel{}}

  """
  def change_parcel(%Parcel{} = parcel, attrs \\ %{}) do
    Parcel.changeset(parcel, attrs)
  end
end
