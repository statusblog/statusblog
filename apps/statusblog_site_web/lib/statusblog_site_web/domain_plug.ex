defmodule StatusblogSiteWeb.DomainPlug do
  import Plug.Conn
  alias Statusblog.Blogs
  alias Statusblog.Blogs.Blog

  def fetch_current_blog(conn, _opts) do
    subdomain = get_subdomain(conn.host)
    blog = Blogs.get_blog_by_subdomain(subdomain)
    assign(conn, :current_blog, blog)
  end

  defp get_subdomain(host) do
    root_host = StatusblogSiteWeb.Endpoint.config(:url)[:host]
    String.replace(host, ".#{root_host}", "")
  end

  def require_current_blog(conn, _ops) do
    case conn.assigns[:current_blog] do
      %Blog{} ->
        conn

      _any ->
        conn
        # todo: redirect to statusblog.io?
        |> Phoenix.Controller.render(StatusblogSiteWeb.ErrorView, :"404")
        |> halt()
    end
  end
end
