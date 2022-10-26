defmodule Mololine.Vehicles do
  @moduledoc """
  The Vehicles context.
  """

  import Ecto.Query, warn: false
  alias Mololine.Repo

  alias Mololine.Vehicles.Vehicle
  alias Mololine.Seatplans.Seatplan
  alias Mololine.Accounts.User

  @doc """
  Returns the list of vehicles.

  ## Examples

      iex> list_vehicles()
      [%Vehicle{}, ...]

  """
  def list_vehicles do
    Repo.all(Vehicle)
  end

  @doc """
  Gets a single vehicle.

  Raises `Ecto.NoResultsError` if the Vehicle does not exist.

  ## Examples

      iex> get_vehicle!(123)
      %Vehicle{}

      iex> get_vehicle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicle!(id), do: Repo.get!(Vehicle, id)

  @doc """
  Creates a vehicle.

  ## Examples

      iex> create_vehicle(%{field: value})
      {:ok, %Vehicle{}}

      iex> create_vehicle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vehicle(attrs \\ %{}) do
    IO.puts attrs["seatplanname"]
    seatplanname = attrs["seatplanname"]
    driveremail = attrs["driveremail"]
    seatplan  = Repo.get_by(Seatplan,name: seatplanname)
    driver  = Repo.get_by(User,email: driveremail)
    IO.puts "seatplan is ...."
    IO.inspect seatplan
    %Vehicle{}
    |> Vehicle.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:seatplan,seatplan)
    |> Ecto.Changeset.put_assoc(:driver,driver)
    |> Repo.insert()

  end

  @doc """
  Updates a vehicle.

  ## Examples

      iex> update_vehicle(vehicle, %{field: new_value})
      {:ok, %Vehicle{}}

      iex> update_vehicle(vehicle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicle(%Vehicle{} = vehicle, attrs) do
    driveremail = attrs["driveremail"]
    driver  = Repo.get_by(User,email: driveremail)
    vehicle
    |> Vehicle.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:driver,driver)
    |> Repo.update()
  end

  @doc """
  Deletes a vehicle.

  ## Examples

      iex> delete_vehicle(vehicle)
      {:ok, %Vehicle{}}

      iex> delete_vehicle(vehicle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicle(%Vehicle{} = vehicle) do
    Repo.delete(vehicle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle changes.

  ## Examples

      iex> change_vehicle(vehicle)
      %Ecto.Changeset{data: %Vehicle{}}

  """
  def change_vehicle(%Vehicle{} = vehicle, attrs \\ %{}) do
    Vehicle.changeset(vehicle, attrs)
  end
end
