defmodule NovaControl.Repo do
  use Ecto.Repo,
    otp_app: :nova_control,
    adapter: Ecto.Adapters.Postgres
end
