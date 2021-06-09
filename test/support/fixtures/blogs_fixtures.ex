defmodule Statusblog.BlogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Statusblog.Blogs` context.
  """

  @doc """
  Generate a unique blog domain.
  """
  def unique_blog_domain, do: "some domain#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique blog subdomain.
  """
  def unique_blog_subdomain, do: "some-subdomain#{System.unique_integer([:positive])}"

  @doc """
  Generate a blog.
  """
  def blog_fixture(attrs \\ %{}) do
    {:ok, blog} =
      attrs
      |> Enum.into(%{
        description: "some description",
        domain: unique_blog_domain(),
        name: "some name",
        subdomain: unique_blog_subdomain()
      })
      |> Statusblog.Blogs.create_blog()

    blog
  end
end
