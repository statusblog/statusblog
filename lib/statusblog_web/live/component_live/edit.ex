defmodule StatusblogWeb.ComponentLive.Edit do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs
  alias Statusblog.Components

  @impl true
  def mount(%{"blog_id" => blog_id, "id" => id}, _session, socket) do
    blog = Blogs.get_blog!(blog_id)
    {:ok,
      socket
      |> assign(:menu, :application)
      |> assign(:blog, blog)
      |> assign(:page_title, "Edit component")
      |> assign(:component, Components.get_component!(id))}
  end
end
