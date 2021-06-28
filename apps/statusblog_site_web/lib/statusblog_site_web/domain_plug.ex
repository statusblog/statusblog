defmodule StatusblogSiteWeb.DomainPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Statusblog.Blogs
  alias Statusblog.Blogs.Blog

  def fetch_current_blog(conn, _opts) do
    if String.ends_with?(conn.host, root_domain()) do
      assign(conn, :current_blog, get_by_subdomain(conn.host))
    else
      assign(conn, :current_blog, Blogs.get_blog_by_domain(conn.host))
    end
  end

  defp get_by_subdomain(host) do
    String.replace(host, ".#{root_domain()}", "")
    |> Blogs.get_blog_by_subdomain()
  end

  defp root_domain(), do: Application.get_env(:statusblog, :root_domain)

  def require_current_blog(conn, _ops) do
    case conn.assigns[:current_blog] do
      %Blog{} ->
        conn

      _any ->
        conn
        # todo: redirect to statusblog.io?
        |> put_status(:not_found)
        |> put_view(StatusblogSiteWeb.ErrorView)
        |> render(:"404")
        |> halt()
    end
  end
end
