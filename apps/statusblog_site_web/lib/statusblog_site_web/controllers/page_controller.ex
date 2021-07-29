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
    |> put_component_uptimes()
    |> render("index.html")
  end

  defp put_component_uptimes(conn) do
    uptimes =
      conn.assigns.components
      |> Enum.map(&Components.get_component_uptime/1)
      |> Enum.reduce(%{}, fn elem, acc -> Map.put(acc, elem.component_id, elem) end)

    assign(conn, :component_uptime_by_id, uptimes)
  end
end
