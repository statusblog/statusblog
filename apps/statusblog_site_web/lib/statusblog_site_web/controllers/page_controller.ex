defmodule StatusblogSiteWeb.PageController do
  use StatusblogSiteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
