defmodule Statusblog.Repo.Migrations.AddSubscriptionsConfirmedAt do
  use Ecto.Migration

  def change do
    alter table(:subscriptions) do
      add :email_token, :text
      add :confirmed_at, :naive_datetime
    end

    create unique_index(:subscriptions, :email_token)
  end
end
