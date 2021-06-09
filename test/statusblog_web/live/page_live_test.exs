defmodule StatusblogWeb.PageLiveTest do
  use StatusblogWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_confirm_and_log_in_user

  test "disconnected and connected render", %{conn: conn} do
    conn = get(conn, "/")
    disconnected_html = html_response(conn, 200)
    {:ok, _live, connected_html} = live(conn)

    assert disconnected_html =~ "Welcome to Phoenix!"
    assert connected_html =~ "Welcome to Phoenix!"
  end
end
