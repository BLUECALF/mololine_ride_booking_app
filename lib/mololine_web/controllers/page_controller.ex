defmodule MololineWeb.PageController do
  use MololineWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
