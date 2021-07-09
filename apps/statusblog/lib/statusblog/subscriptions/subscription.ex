defmodule Statusblog.Subscriptions.Subscription do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Statusblog.Blogs.Blog

  schema "subscriptions" do
    field :email, :string
    field :confirmed_at, :utc_datetime
    field :confirmation_token, :string
    belongs_to :blog, Blog

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:email, :confirmed_at, :confirmation_token])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique([:email, :blog_id], Statusblog.Repo)
    |> unique_constraint([:email, :blog_id])
  end

  def token_query(%Blog{} = blog, token) do
    from s in __MODULE__,
      where: s.blog_id == ^blog.id and s.confirmation_token == ^token
  end
end
