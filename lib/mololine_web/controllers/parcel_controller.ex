defmodule MololineWeb.ParcelController do
  use MololineWeb, :controller

  alias Mololine.Resources
  alias Mololine.Repo
  alias Mololine.Accounts.User
  alias Mololine.Resources.Parcel

  action_fallback MololineWeb.FallbackController

  def index(conn, _params) do
    parcels = Resources.list_parcels()
    render(conn, "index.html", parcels: parcels)
  end

  def customer_index(conn, _params) do
    user_id = conn.assigns.current_user.id
    IO.puts "The user id is :#{user_id}"
    user = Repo.get(User,user_id) |> Repo.preload(:parcels)
    parcels = user.parcels
    render(conn, "index.html", parcels: parcels)
  end

  def new(conn, _params) do
    changeset = Resources.change_parcel(%Parcel{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"parcel" => parcel_params}) do
    user = conn.assigns.current_user
    case Resources.create_parcel(parcel_params,user) do
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
      parcel ->
        conn
        |> put_flash(:info, "Parcel created successfully.")
        |> redirect(to: Routes.parcel_path(conn, :show, parcel))
    end
  end

  def show(conn, %{"id" => id}) do
    parcel = Resources.get_parcel!(id)
    render(conn, "show.html", parcel: parcel)
  end

  def edit(conn, %{"id" => id}) do
    parcel = Resources.get_parcel!(id)
    changeset = Resources.change_parcel(parcel)
    render(conn, "edit.html", parcel: parcel, changeset: changeset)
  end

  def update(conn, %{"id" => id, "parcel" => parcel_params}) do
    parcel = Resources.get_parcel!(id)

    case Resources.update_parcel(parcel, parcel_params) do
      {:ok, parcel} ->
        conn
        |> put_flash(:info, "Parcel updated successfully.")
        |> redirect(to: Routes.parcel_path(conn, :show, parcel))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", parcel: parcel, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    parcel = Resources.get_parcel!(id)
    {response, _parcel} = Resources.delete_parcel(parcel, conn.assigns.current_user)

    case response do

    :ok ->
      conn
      |> put_flash(:info, "Parcel deleted successfully.")
      |> redirect(to: Routes.parcel_path(conn, :index))
    :error -> MololineWeb.FallbackController.call(conn,{response, :unauthorized})

    end
  end
end
