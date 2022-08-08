defmodule Mololine.ParcelBookings do
  @moduledoc """
  The ParcelBookings context.
  """

  import Ecto.Query, warn: false
  alias Mololine.Repo

  alias Mololine.ParcelBookings.ParcelDeliveryBooking

  @doc """
  Returns the list of parceldeliverybooking.

  ## Examples

      iex> list_parceldeliverybooking()
      [%ParcelDeliveryBooking{}, ...]

  """
  def list_parceldeliverybooking do
    Repo.all(ParcelDeliveryBooking)
  end

  @doc """
  Gets a single parcel_delivery_booking.

  Raises `Ecto.NoResultsError` if the Parcel delivery booking does not exist.

  ## Examples

      iex> get_parcel_delivery_booking!(123)
      %ParcelDeliveryBooking{}

      iex> get_parcel_delivery_booking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parcel_delivery_booking!(id), do: Repo.get!(ParcelDeliveryBooking, id)

  @doc """
  Creates a parcel_delivery_booking.

  ## Examples

      iex> create_parcel_delivery_booking(%{field: value})
      {:ok, %ParcelDeliveryBooking{}}

      iex> create_parcel_delivery_booking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parcel_delivery_booking(attrs \\ %{}) do
    %ParcelDeliveryBooking{}
    |> ParcelDeliveryBooking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a parcel_delivery_booking.

  ## Examples

      iex> update_parcel_delivery_booking(parcel_delivery_booking, %{field: new_value})
      {:ok, %ParcelDeliveryBooking{}}

      iex> update_parcel_delivery_booking(parcel_delivery_booking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parcel_delivery_booking(%ParcelDeliveryBooking{} = parcel_delivery_booking, attrs) do
    parcel_delivery_booking
    |> ParcelDeliveryBooking.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a parcel_delivery_booking.

  ## Examples

      iex> delete_parcel_delivery_booking(parcel_delivery_booking)
      {:ok, %ParcelDeliveryBooking{}}

      iex> delete_parcel_delivery_booking(parcel_delivery_booking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parcel_delivery_booking(%ParcelDeliveryBooking{} = parcel_delivery_booking) do
    Repo.delete(parcel_delivery_booking)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parcel_delivery_booking changes.

  ## Examples

      iex> change_parcel_delivery_booking(parcel_delivery_booking)
      %Ecto.Changeset{data: %ParcelDeliveryBooking{}}

  """
  def change_parcel_delivery_booking(%ParcelDeliveryBooking{} = parcel_delivery_booking, attrs \\ %{}) do
    ParcelDeliveryBooking.changeset(parcel_delivery_booking, attrs)
  end
end
