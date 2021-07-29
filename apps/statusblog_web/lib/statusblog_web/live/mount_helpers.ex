defmodule StatusblogWeb.MountHelpers do
  import Phoenix.LiveView
  alias Statusblog.Accounts
  alias Statusblog.Blogs

  def assign_defaults(socket, params, session) do
    socket
    |> assign_current_user(session)
    |> assign_current_blog(params)
    |> assign_user_blogs()
    |> ensure_access()
  end

  def assign_current_user(socket, session) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token!(session["user_token"])
    end)
  end

  defp assign_current_blog(socket, params) do
    assign_new(socket, :blog, fn ->
      params["blog_id"] && Blogs.get_blog!(params["blog_id"])
    end)
  end

  defp assign_user_blogs(socket) do
    assign_new(socket, :blogs, fn ->
      Blogs.list_blogs(socket.assigns.current_user)
    end)
  end

  defp ensure_access(socket) do
    blog = socket.assigns.blog
    blogs = socket.assigns.blogs

    cond do
      blog && not Enum.member?(blogs, blog) ->
        socket
        |> put_flash(:error, "Access denied")
        |> push_redirect(to: "/")

      true ->
        socket
    end
  end
end
