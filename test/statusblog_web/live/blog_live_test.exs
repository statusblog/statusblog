defmodule StatusblogWeb.BlogLiveTest do
  use StatusblogWeb.ConnCase

  import Phoenix.LiveViewTest
  import Statusblog.BlogsFixtures

  @create_attrs %{description: "some description", domain: "some domain", name: "some name", subdomain: "some-subdomain"}
  @update_attrs %{description: "some updated description", domain: "some updated domain", name: "some updated name", subdomain: "some-updated-subdomain"}
  @invalid_attrs %{description: nil, domain: nil, name: nil, subdomain: nil}

  setup :register_and_confirm_and_log_in_user

  defp create_blog(_) do
    blog = blog_fixture()
    %{blog: blog}
  end

  describe "Index" do
    setup [:create_blog]

    test "lists all blogs", %{conn: conn, blog: blog} do
      {:ok, _index_live, html} = live(conn, Routes.blog_index_path(conn, :index))

      assert html =~ "Listing Blogs"
      assert html =~ blog.description
    end

    test "saves new blog", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.blog_index_path(conn, :index))

      assert index_live |> element("a", "New Blog") |> render_click() =~
               "New Blog"

      assert_patch(index_live, Routes.blog_index_path(conn, :new))

      assert index_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#blog-form", blog: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.blog_index_path(conn, :index))

      assert html =~ "Blog created successfully"
      assert html =~ "some description"
    end

    test "updates blog in listing", %{conn: conn, blog: blog} do
      {:ok, index_live, _html} = live(conn, Routes.blog_index_path(conn, :index))

      assert index_live |> element("#blog-#{blog.id} a", "Edit") |> render_click() =~
               "Edit Blog"

      assert_patch(index_live, Routes.blog_index_path(conn, :edit, blog))

      assert index_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#blog-form", blog: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.blog_index_path(conn, :index))

      assert html =~ "Blog updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes blog in listing", %{conn: conn, blog: blog} do
      {:ok, index_live, _html} = live(conn, Routes.blog_index_path(conn, :index))

      assert index_live |> element("#blog-#{blog.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#blog-#{blog.id}")
    end
  end

  describe "Show" do
    setup [:create_blog]

    test "displays blog", %{conn: conn, blog: blog} do
      {:ok, _show_live, html} = live(conn, Routes.blog_show_path(conn, :show, blog))

      assert html =~ "Show Blog"
      assert html =~ blog.description
    end

    test "updates blog within modal", %{conn: conn, blog: blog} do
      {:ok, show_live, _html} = live(conn, Routes.blog_show_path(conn, :show, blog))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Blog"

      assert_patch(show_live, Routes.blog_show_path(conn, :edit, blog))

      assert show_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#blog-form", blog: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.blog_show_path(conn, :show, blog))

      assert html =~ "Blog updated successfully"
      assert html =~ "some updated description"
    end
  end
end
