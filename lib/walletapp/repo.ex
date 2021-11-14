defmodule Walletapp.Repo do
  use Ecto.Repo,
    otp_app: :walletapp,
    adapter: Ecto.Adapters.Postgres
end
