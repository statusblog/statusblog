defmodule Statusblog.Repo do
  use Ecto.Repo,
    otp_app: :statusblog,
    adapter: Ecto.Adapters.Postgres
end
