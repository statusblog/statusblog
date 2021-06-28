defmodule StatusblogWeb.TlsController do
  use StatusblogWeb, :controller
  alias Statusblog.Blogs
  alias Statusblog.Blogs.Blog

  def ask(conn, %{"domain" => domain}) do
    case Blogs.get_blog_by_domain(domain) do
      %Blog{} -> send_resp(conn, 200, "OK")
      _ -> send_resp(conn, 404, "Not found")
    end
  end

end
