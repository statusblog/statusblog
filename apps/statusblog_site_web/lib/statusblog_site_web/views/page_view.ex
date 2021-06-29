defmodule StatusblogSiteWeb.PageView do
  use StatusblogSiteWeb, :view
  alias Statusblog.Components.Component

  defp overall_status_widget(components), do: status_widget(overall_status(components))

  defp overall_status([]), do: :operational
  defp overall_status(components) do
    components
    |> Enum.map(fn c -> c.status end)
    |> Enum.max_by(fn x -> Enum.find_index(Component.status_values(), fn y -> y == x end) end)
  end

  defp status_widget(status) do
    ~E"""
    <div class="py-3 px-4 text-white font-semibold text-xl rounded <%= status_widget_class(status) %>">
      <%= status_widget_text(status) %>
    </div>
    """
  end

  defp status_widget_class(:operational), do: "bg-green-500"
  defp status_widget_class(:under_maintenance), do: "bg-blue-500"
  defp status_widget_class(:degraded_performance), do: "bg-yellow-300"
  defp status_widget_class(:partial_outage), do: "bg-yellow-600"
  defp status_widget_class(:major_outage), do: "bg-red-600"

  defp status_widget_text(:operational), do: "All Systems Operational"
  defp status_widget_text(:under_maintenance), do: "Service Under Maintenance"
  defp status_widget_text(:degraded_performance), do: "Partially Degraded Service"
  defp status_widget_text(:partial_outage), do: "Minor Service Outage"
  defp status_widget_text(:major_outage), do: "Major Service Outage"
end
