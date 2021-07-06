defmodule Statusblog.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :email, :citext
      add :blog_id, references(:blogs, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:subscriptions, [:blog_id])
    create unique_index(:subscriptions, [:blog_id, :email])
  end
end
