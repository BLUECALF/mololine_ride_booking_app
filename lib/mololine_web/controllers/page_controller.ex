defmodule MololineWeb.PageController do
  use MololineWeb, :controller

  alias Mololine.Towns
  def index(conn, _params) do
    role = conn.assigns.current_user.role
    towns = Towns.list_towns()
    case role do
      "customer" -> #render(conn, "customer.html")
        render(conn, "customer.html",towns: towns)
      "admin" -> render(conn, "admin.html")
      "driver" -> render(conn, "driver.html")
      "accountant" -> render(conn, "accountant.html")
      "hr" -> redirect(conn,to: "/hrlive")
      "manager" -> render(conn, "manager.html")
      end
  end
end
