defmodule StatusblogWeb.ComponentLive.Index do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs
  alias Statusblog.Components

  @impl true
  def mount(%{"blog_id" => blog_id}, _session, socket) do
    # todo: validate blog_id is valid
    IO.puts "fetching..."
    blog = Blogs.get_blog!(blog_id)
    IO.inspect blog

    {:ok,
      socket
      |> assign(:components, Components.list_components(blog_id))
      |> assign(:page_title, "Components")
      |> assign(:menu, :components)
      |> assign(:blog, blog)}
  end

end
