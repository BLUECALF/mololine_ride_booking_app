defmodule Mololine.Repo do
  use Ecto.Repo,
    otp_app: :mololine,
    adapter: Ecto.Adapters.Postgres
end
