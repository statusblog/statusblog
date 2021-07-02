defmodule Statusblog.Repo.Migrations.CreateBlogsMemberships do
  use Ecto.Migration

  def change do
    create table(:blogs_memberships) do
      add :role, :text, null: false
      add :blog_id, references(:blogs, on_delete: :delete_all), null: false
      add :member_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:blogs_memberships, [:blog_id, :member_id])
  end
end
