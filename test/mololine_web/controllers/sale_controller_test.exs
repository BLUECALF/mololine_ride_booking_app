defmodule MololineWeb.SaleControllerTest do
  use MololineWeb.ConnCase

  import Mololine.SalesFixtures

  @create_attrs %{amount: 42, date: ~D[2022-11-03], from: "some from", reason: "some reason", to: "some to"}
  @update_attrs %{amount: 43, date: ~D[2022-11-04], from: "some updated from", reason: "some updated reason", to: "some updated to"}
  @invalid_attrs %{amount: nil, date: nil, from: nil, reason: nil, to: nil}

  describe "index" do
    test "lists all sales", %{conn: conn} do
      conn = get(conn, Routes.sale_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Sales"
    end
  end

  describe "new sale" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.sale_path(conn, :new))
      assert html_response(conn, 200) =~ "New Sale"
    end
  end

  describe "create sale" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.sale_path(conn, :create), sale: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.sale_path(conn, :show, id)

      conn = get(conn, Routes.sale_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Sale"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.sale_path(conn, :create), sale: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Sale"
    end
  end

  describe "edit sale" do
    setup [:create_sale]

    test "renders form for editing chosen sale", %{conn: conn, sale: sale} do
      conn = get(conn, Routes.sale_path(conn, :edit, sale))
      assert html_response(conn, 200) =~ "Edit Sale"
    end
  end

  describe "update sale" do
    setup [:create_sale]

    test "redirects when data is valid", %{conn: conn, sale: sale} do
      conn = put(conn, Routes.sale_path(conn, :update, sale), sale: @update_attrs)
      assert redirected_to(conn) == Routes.sale_path(conn, :show, sale)

      conn = get(conn, Routes.sale_path(conn, :show, sale))
      assert html_response(conn, 200) =~ "some updated from"
    end

    test "renders errors when data is invalid", %{conn: conn, sale: sale} do
      conn = put(conn, Routes.sale_path(conn, :update, sale), sale: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Sale"
    end
  end

  describe "delete sale" do
    setup [:create_sale]

    test "deletes chosen sale", %{conn: conn, sale: sale} do
      conn = delete(conn, Routes.sale_path(conn, :delete, sale))
      assert redirected_to(conn) == Routes.sale_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.sale_path(conn, :show, sale))
      end
    end
  end

  defp create_sale(_) do
    sale = sale_fixture()
    %{sale: sale}
  end
end
