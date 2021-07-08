defmodule Statusblog.Repo.Migrations.AddSubscriptionsConfirmedAt do
  use Ecto.Migration

  def change do
    alter table(:subscriptions) do
      add :confirmation_token, :text
      add :confirmed_at, :naive_datetime
   end
  end
end
