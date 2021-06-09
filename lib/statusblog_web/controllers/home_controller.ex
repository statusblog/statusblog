defmodule StatusblogWeb.HomeController do
  use StatusblogWeb, :controller

  def index(conn, _params) do
    # todo:
    # fetch first blog that user is member of - if exists, redirect
    # if none found, redirect to "/blogs/new"
    redirect(conn, to: Routes.user_settings_path(conn, :edit))
  end

end
