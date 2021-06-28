defmodule Statusblog.Repo.Migrations.CreateComponents do
  use Ecto.Migration

  def change do
    create table(:components) do
      add :name, :string, null: false
      add :description, :string
      add :position, :integer, null: false
      add :status, :string, null: false
      add :display_uptime, :boolean, default: false, null: false
      add :start_date, :date, null: false
      add :blog_id, references(:blogs, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:components, [:blog_id, :position])
    create index(:components, [:blog_id])
  end
end