defmodule MololineWeb.ItemController do
  use MololineWeb, :controller

  alias Mololine.Inventory
  alias Mololine.Repo
  alias Mololine.Resources.Parcel
  alias Mololine.Accounts.User
  alias Mololine.Inventory.Item

  def index(conn, _params) do
    items = Inventory.list_items()
    if(conn.assigns.current_user.role != "admin" ) do
      # redirect to parcel_customer page
      conn
      |> redirect(to: Routes.item_path(conn, :customer_index, []))
    else
      #user iz admin
      render(conn, "index.html", items: items)
    end
  end

  def customer_index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get(User,user_id) |> Repo.preload(:parcels)
    if( user.role == "accountant") do
      # redirect to accountant_index page
      conn
      |> redirect(to: Routes.item_path(conn, :accountant_index, []))
      else
      parcels = user.parcels
      items =  for parcel <- parcels do
        Repo.get_by(Item,parcel_id: parcel.id)
      end
      render(conn, "index.html", items: items)
    end
  end
  def accountant_index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get(User,user_id) |> Repo.preload(:town)
    town_name = user.town.name

    import Ecto.Query, only: [from: 2]

    query = from item in "items",
                 where: item.town == ^town_name,
                 select: item.id

    # Send the query to the repository
    item_list  = Repo.all(query)
    items =  for id <- item_list do
      Repo.get_by(Item,id: id)
    end
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Inventory.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    user_id = conn.assigns.current_user.id;
    user = Repo.get(User,user_id) |> Repo.preload(:town)
    if(user.town == nil) do
      conn
    |> put_flash(:error, "You have not been assigned to a town and cannot make items to inventory")
    |> redirect(to: Routes.item_path(conn, :index))

    else
    # check if the parcel exists
      parcel_id = item_params["parcel_id"]
      if(Repo.get(Parcel,parcel_id) ==nil) do
        conn
        |> put_flash(:error, "Parcel with ID #{parcel_id} does not exist")
        |> redirect(to: Routes.item_path(conn, :index))
        else
        # continue with normal stuff
        town = user.town.name;
        item_params  = Map.put(item_params,"town",town)
        IO.inspect item_params
        case Inventory.create_item(item_params) do
          {:ok, item} ->
            conn
            |> put_flash(:info, "Item created successfully.")
            |> redirect(to: Routes.item_path(conn, :show, item))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end
      end
  end

  def show(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)
    changeset = Inventory.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Inventory.get_item!(id)

    case Inventory.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: Routes.item_path(conn, :show, item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)
    {:ok, _item} = Inventory.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.item_path(conn, :index))
  end
end
