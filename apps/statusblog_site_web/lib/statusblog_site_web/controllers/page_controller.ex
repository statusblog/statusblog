defmodule StatusblogSiteWeb.PageController do
  use StatusblogSiteWeb, :controller
  alias Statusblog.Incidents
  alias Statusblog.Components

  def index(conn, _params) do
    blog_id = conn.assigns.current_blog.id

    conn
    |> assign(:open_incidents, Incidents.list_open_incidents(blog_id))
    |> assign(:resolved_incidents, Incidents.list_resolved_incidents(blog_id))
    |> assign(:components, Components.list_components(blog_id))
    |> render("index.html")
  end
end
