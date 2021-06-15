defmodule Statusblog.Blogs.Membership do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Blogs.{Blog, Member}

  schema "blogs_memberships" do
    field :role, Ecto.Enum, values: [:member, :admin]
    belongs_to :blog, Blog
    belongs_to :member, Member

    timestamps()
  end

  def insert_changeset(blog, user, role) do
    change(%__MODULE__{
      blog_id: blog.id,
      member_id: user.id,
      role: role
    })
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end
end
