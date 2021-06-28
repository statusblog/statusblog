defmodule Statusblog.Blogs.Blog do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Statusblog.Blogs.Membership

  schema "blogs" do
    field :description, :string
    field :domain, :string
    field :name, :string
    field :subdomain, :string

    has_many :memberships, Membership

    timestamps()
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:name, :description, :subdomain, :domain])
    |> validate_required([:name])
    |> validate_subdomain()
    |> validate_domain()
  end

  defp validate_subdomain(changeset) do
    changeset
    |> validate_required([:subdomain])
    |> validate_format(:subdomain, ~r/^(?![0-9]+$)(?!.*-$)(?!-)[a-zA-Z0-9-]{1,63}$/,
      message: "must only contain characters a-z, 0-9, hyphens, and cannot begin with a hyphen")
    |> validate_exclusion(:subdomain, Application.get_env(:statusblog, :subdomain_denylist))
    |> unique_constraint(:subdomain)
  end

  defp validate_domain(changeset) do
    changeset
    # source: https://blog.bejarano.io/domain-name-validation-with-regular-expressions/
    |> validate_format(:domain, ~r/^(?=.{4,255}$)([a-zA-Z0-9_]([a-zA-Z0-9_-]{0,61}[a-zA-Z0-9_])?\.){1,126}[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]$/,
      message: "invalid domain")
    |> unique_constraint(:domain)
  end

  def by_user(user) do
    from(b in __MODULE__,
      join: ms in assoc(b, :memberships),
      on: [member_id: ^user.id]
    )
  end

  def by_subdomain(subdomain) do
    from(b in __MODULE__, where: b.subdomain == ^subdomain)
  end
end
