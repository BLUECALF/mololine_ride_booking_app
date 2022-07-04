defmodule MololineWeb.FallbackController do
  use MololineWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(MololineWeb.ErrorView)
    |> render(:"403")
  end
end
