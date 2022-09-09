defmodule MololineWeb.PageController do
  use MololineWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
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
