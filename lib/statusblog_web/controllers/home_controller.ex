defmodule StatusblogWeb.HomeController do
  use StatusblogWeb, :controller

  def index(_conn, _params) do
    # todo:
    # fetch first blog that user is member of - if exists, redirect
    # if none found, redirect to "/blogs/new"
  end

end
