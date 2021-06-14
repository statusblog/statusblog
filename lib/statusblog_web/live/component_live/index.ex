defmodule StatusblogWeb.ComponentLive.Index do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs
  alias Statusblog.Components
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(%{"blog_id" => blog_id}, session, socket) do
    # todo: validate blog_id is valid
    blog = Blogs.get_blog!(blog_id)

    {:ok,
      socket
      |> MountHelpers.assign_defaults(session)
      |> assign(:components, Components.list_components(blog_id))
      |> assign(:page_title, "Components")
      |> assign(:menu, :components)
      |> assign(:blog, blog)}
  end

end
