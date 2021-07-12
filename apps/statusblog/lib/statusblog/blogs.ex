defmodule Statusblog.Blogs do
  @moduledoc """
  The Blogs context.
  """

  import Ecto.Query, warn: false
  alias Statusblog.Repo

  alias Statusblog.Blogs.{Blog, Membership}

  def list_blogs(user) do
    user
    |> Blog.by_user()
    |> Repo.all()
  end

  def list_blogs() do
    Repo.all(Blog)
  end

  @doc """
  Gets a single blog.

  Raises `Ecto.NoResultsError` if the Blog does not exist.

  ## Examples

      iex> get_blog!(123)
      %Blog{}

      iex> get_blog!(456)
      ** (Ecto.NoResultsError)

  """
  def get_blog!(id), do: Repo.get!(Blog, id)

  def get_blog_by_subdomain(subdomain) do
    subdomain
    |> Blog.by_subdomain()
    |> Repo.one()
  end

  def get_blog_by_domain(domain) do
    domain
    |> Blog.by_domain()
    |> Repo.one()
  end

  # TODO: need to handle HTTPS or not
  def get_blog_base_url!(blog_id) when is_integer(blog_id) do
    get_blog!(blog_id)
    |> get_blog_base_url!()
  end

  def get_blog_base_url!(%Blog{} = blog) do
    if blog.domain do
      "http://#{blog.domain}"
    else
      root_domain = Application.get_env(:statusblog, :root_domain)
      "http://#{blog.subdomain}.#{root_domain}"
    end
  end

  @doc """
  Creates a blog.

  ## Examples

      iex> create_blog(%{field: value})
      {:ok, %Blog{}}

      iex> create_blog(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_blog(user, attrs \\ %{}) do
    blog_changest = Blog.changeset(%Blog{}, attrs)

    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:blog, blog_changest)
      |> Ecto.Multi.insert(:membership, fn %{blog: blog} ->
        Membership.insert_changeset(blog, user, :admin)
      end)

    case Repo.transaction(multi) do
      {:ok, %{blog: blog}} ->
        {:ok, blog}

      {:error, :blog, changeset, _} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a blog.

  ## Examples

      iex> update_blog(blog, %{field: new_value})
      {:ok, %Blog{}}

      iex> update_blog(blog, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_blog(%Blog{} = blog, attrs) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a blog.

  ## Examples

      iex> delete_blog(blog)
      {:ok, %Blog{}}

      iex> delete_blog(blog)
      {:error, %Ecto.Changeset{}}

  """
  def delete_blog(%Blog{} = blog) do
    Repo.delete(blog)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blog changes.

  ## Examples

      iex> change_blog(blog)
      %Ecto.Changeset{data: %Blog{}}

  """
  def change_blog(%Blog{} = blog, attrs \\ %{}) do
    Blog.changeset(blog, attrs)
  end
end
