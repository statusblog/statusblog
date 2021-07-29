defmodule Statusblog.BlogsTest do
  use Statusblog.DataCase

  alias Statusblog.Blogs

  describe "blogs" do
    alias Statusblog.Blogs.Blog

    import Statusblog.BlogsFixtures
    import Statusblog.AccountsFixtures

    @invalid_attrs %{description: nil, domain: nil, name: nil, subdomain: nil}

    test "list_blogs/0 returns all blogs" do
      blog = blog_fixture()
      assert Blogs.list_blogs() == [blog]
    end

    test "list_blogs/1 filters by user" do
      user1 = confirmed_user_fixture()
      blog1 = blog_fixture(user1)

      user2 = confirmed_user_fixture()
      _blog2 = blog_fixture(user2)

      [loaded] = Blogs.list_blogs(user1)
      assert loaded.id == blog1.id
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = blog_fixture()
      assert Blogs.get_blog!(blog.id) == blog
    end

    test "create_blog/1 with valid data creates a blog" do
      valid_attrs = %{
        description: "some description",
        domain: "some.domain",
        name: "some name",
        subdomain: "some-subdomain"
      }

      assert {:ok, %Blog{} = blog} = Blogs.create_blog(confirmed_user_fixture(), valid_attrs)
      assert blog.description == "some description"
      assert blog.domain == "some.domain"
      assert blog.name == "some name"
      assert blog.subdomain == "some-subdomain"
    end

    test "create_blog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Blogs.create_blog(confirmed_user_fixture(), @invalid_attrs)
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = blog_fixture()

      update_attrs = %{
        description: "some updated description",
        domain: "some-updated.domain",
        name: "some updated name",
        subdomain: "some-updated-subdomain"
      }

      assert {:ok, %Blog{} = blog} = Blogs.update_blog(blog, update_attrs)
      assert blog.description == "some updated description"
      assert blog.domain == "some-updated.domain"
      assert blog.name == "some updated name"
      assert blog.subdomain == "some-updated-subdomain"
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = blog_fixture()
      assert {:error, %Ecto.Changeset{}} = Blogs.update_blog(blog, @invalid_attrs)
      assert blog == Blogs.get_blog!(blog.id)
    end

    test "delete_blog/1 deletes the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{}} = Blogs.delete_blog(blog)
      assert_raise Ecto.NoResultsError, fn -> Blogs.get_blog!(blog.id) end
    end

    test "change_blog/1 returns a blog changeset" do
      blog = blog_fixture()
      assert %Ecto.Changeset{} = Blogs.change_blog(blog)
    end
  end
end
