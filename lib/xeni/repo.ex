defmodule Xeni.Repo do
  use Ecto.Repo,
    otp_app: :xeni,
    adapter: Ecto.Adapters.Postgres
end
