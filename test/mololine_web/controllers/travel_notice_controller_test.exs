defmodule MololineWeb.TravelNoticeControllerTest do
  use MololineWeb.ConnCase

  import Mololine.NoticesFixtures

  @create_attrs %{from: "some from", price: 42, to: "some to"}
  @update_attrs %{from: "some updated from", price: 43, to: "some updated to"}
  @invalid_attrs %{from: nil, price: nil, to: nil}

  describe "index" do
    test "lists all travelnotices", %{conn: conn} do
      conn = get(conn, Routes.travel_notice_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Travelnotices"
    end
  end

  describe "new travel_notice" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.travel_notice_path(conn, :new))
      assert html_response(conn, 200) =~ "New Travel notice"
    end
  end

  describe "create travel_notice" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.travel_notice_path(conn, :create), travel_notice: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.travel_notice_path(conn, :show, id)

      conn = get(conn, Routes.travel_notice_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Travel notice"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.travel_notice_path(conn, :create), travel_notice: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Travel notice"
    end
  end

  describe "edit travel_notice" do
    setup [:create_travel_notice]

    test "renders form for editing chosen travel_notice", %{conn: conn, travel_notice: travel_notice} do
      conn = get(conn, Routes.travel_notice_path(conn, :edit, travel_notice))
      assert html_response(conn, 200) =~ "Edit Travel notice"
    end
  end

  describe "update travel_notice" do
    setup [:create_travel_notice]

    test "redirects when data is valid", %{conn: conn, travel_notice: travel_notice} do
      conn = put(conn, Routes.travel_notice_path(conn, :update, travel_notice), travel_notice: @update_attrs)
      assert redirected_to(conn) == Routes.travel_notice_path(conn, :show, travel_notice)

      conn = get(conn, Routes.travel_notice_path(conn, :show, travel_notice))
      assert html_response(conn, 200) =~ "some updated from"
    end

    test "renders errors when data is invalid", %{conn: conn, travel_notice: travel_notice} do
      conn = put(conn, Routes.travel_notice_path(conn, :update, travel_notice), travel_notice: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Travel notice"
    end
  end

  describe "delete travel_notice" do
    setup [:create_travel_notice]

    test "deletes chosen travel_notice", %{conn: conn, travel_notice: travel_notice} do
      conn = delete(conn, Routes.travel_notice_path(conn, :delete, travel_notice))
      assert redirected_to(conn) == Routes.travel_notice_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.travel_notice_path(conn, :show, travel_notice))
      end
    end
  end

  defp create_travel_notice(_) do
    travel_notice = travel_notice_fixture()
    %{travel_notice: travel_notice}
  end
end
