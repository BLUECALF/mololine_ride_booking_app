defmodule MololineWeb.SaleController do
  use MololineWeb, :controller

  alias Mololine.Sales
  alias Mololine.Sales.Sale

  def index(conn, _params) do
    sales = Sales.list_sales()
    total_amount = for sale <- sales do
      sale.amount
    end
    today = DateTime.utc_now()
    total_amount_this_month = for sale <- sales do
      if(sale.date.month == today.month and sale.date.year == today.year) do
      sale.amount
      end
    end

    total = sumList(total_amount)
    total_in_month = sumList(total_amount_this_month)
    render(conn, "index.html", sales: sales, total: total, total_in_month: total_in_month)
  end

  def new(conn, _params) do
    changeset = Sales.change_sale(%Sale{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sale" => sale_params}) do
    case Sales.create_sale(sale_params) do
      {:ok, sale} ->
        conn
        |> put_flash(:info, "Sale created successfully.")
        |> redirect(to: Routes.sale_path(conn, :show, sale))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sale = Sales.get_sale!(id)
    render(conn, "show.html", sale: sale)
  end

  def edit(conn, %{"id" => id}) do
    sale = Sales.get_sale!(id)
    changeset = Sales.change_sale(sale)
    render(conn, "edit.html", sale: sale, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sale" => sale_params}) do
    sale = Sales.get_sale!(id)

    case Sales.update_sale(sale, sale_params) do
      {:ok, sale} ->
        conn
        |> put_flash(:info, "Sale updated successfully.")
        |> redirect(to: Routes.sale_path(conn, :show, sale))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sale: sale, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sale = Sales.get_sale!(id)
    {:ok, _sale} = Sales.delete_sale(sale)

    conn
    |> put_flash(:info, "Sale deleted successfully.")
    |> redirect(to: Routes.sale_path(conn, :index))
  end

  defp sumList([h|t]) do
    h + sumList(t)
  end
  defp sumList([]) do
    0
  end
end
