defmodule StatusblogWeb.LayoutView do
  use StatusblogWeb, :view

  def flash_alerts(conn) do
    get_flash(conn)
    |> Enum.map(fn {type, msg} -> flash_alert(type, msg) end)
  end

  def flash_alert(type, msg) do
    ~E"""
    <div
      x-data="{ show: true }"
      x-show.transition="show"
      x-init="setTimeout(() => show = false, 4000)"
      class="notification is-light <%= flash_alert_class(type) %>"
      style="top: 5%;left: 50%;transform: translate(-50%);position: fixed;"
    >
      <button x-on:click="show = false" class="delete"></button>
      <%= msg %>
    </div>
    """
  end

  defp flash_alert_class("info"), do: "is-info"
  defp flash_alert_class("error"), do: "is-danger"

end
