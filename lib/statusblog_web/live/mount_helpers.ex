defmodule StatusblogWeb.MountHelpers do
  import Phoenix.LiveView
  alias Statusblog.Accounts
  alias Statusblog.Blogs

  def assign_defaults(socket, params, session) do
    socket
    |> assign_current_user(session)
    |> assign_current_blog(params)
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
end
