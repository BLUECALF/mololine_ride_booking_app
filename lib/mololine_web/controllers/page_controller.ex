defmodule MololineWeb.PageController do
  use MololineWeb, :controller

  def index(conn, _params) do
    role = conn.assigns.current_user.role
    case role do
      "customer" -> #render(conn, "customer.html")
        render(conn, "admin.html")
      "admin" -> render(conn, "admin.html")
      "driver" -> render(conn, "driver.html")
      "accountant" -> render(conn, "accountant.html")
      "hr" -> redirect(conn,to: "/hrlive")
      "manager" -> render(conn, "manager.html")
      end
  end
end
