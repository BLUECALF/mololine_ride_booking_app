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

  def home(conn, _params) do
    user = conn.assigns.current_user
    role = user.role

    case role do
    "customer" -> render(conn,"customer_page.html")
    "driver" -> render(conn,"driver_page.html")
    "conductor" -> render(conn,"conductor_page.html")
    "manager" -> render(conn,"manager_page.html")
    "hr" -> render(conn,"hr_page.html")
    "accountant" -> render(conn,"accountant_page.html")
    _ -> render(conn, "index.html")
    end
  end
end
