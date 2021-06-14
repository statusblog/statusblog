defmodule StatusblogWeb.ComponentLive.New do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs
  alias Statusblog.Components
  alias Statusblog.Components.Component
  alias StatusblogWeb.MountHelpers

  def mount(%{"blog_id" => blog_id}, session, socket) do
    blog = Blogs.get_blog!(blog_id)
    {:ok,
      socket
      |> MountHelpers.assign_defaults(session)
      |> assign(:menu, :components)
      |> assign(:blog, blog)
      |> assign(:page_title, "New component")
      |> assign(:component, %Component{})}
  end
end
