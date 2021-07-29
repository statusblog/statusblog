defmodule StatusblogWeb.HomeController do
  use StatusblogWeb, :controller

  alias Statusblog.Blogs

  def index(conn, _params) do
    user = conn.assigns[:current_user]

    case Blogs.list_blogs(user) do
      [blog | _] ->
        redirect(conn, to: Routes.blog_edit_path(conn, :edit, blog))

      [] ->
        redirect(conn, to: Routes.blog_new_path(conn, :new))
    end
  end
end
