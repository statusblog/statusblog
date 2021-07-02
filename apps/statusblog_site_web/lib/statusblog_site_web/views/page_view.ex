defmodule StatusblogSiteWeb.PageView do
  use StatusblogSiteWeb, :view
  alias Statusblog.Components.Component

  #
  # Status widget / active incidents
  #

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

  #
  # Components
  #

  defp uptime_svg(days) do
    ~E"""
    <svg class="w-full mt-2" preserveAspectRatio="none" height="34" viewBox="0 0 448 34">
      <%= for {day, num} <- Enum.with_index(days) do %>
      <rect class="hover:text-gray-500 <%= uptime_rect_class(day) %> fill-current" height="34" width="3" x="<%= num * 5 %>" y="0" class=""></rect>
      <% end %>
    </svg>
    """
  end

  defp uptime_rect_class(day) do
    cond do
      day.major_outage_seconds > 0 -> "text-red-500"
      day.partial_outage_seconds > 0 -> "text-yellow-600"
      day.degraded_performance_seconds > 0 -> "text-yellow-300"
      day.under_maintenance_seconds > 0 || day.operational_seconds > 0 -> "text-green-500"
      true -> "text-gray-300"
    end
  end

  defp status_text_class(:operational), do: "text-green-600"
  defp status_text_class(:under_maintenance), do: "text-blue-600"
  defp status_text_class(:degraded_performance), do: "text-yellow-400"
  defp status_text_class(:partial_outage), do: "text-yellow-600"
  defp status_text_class(:major_outage), do: "text-red-600"


  #defp get_uptime_svg()

  #
  # Incident history
  #

  # returns [{date, incidents}...]
  defp recent_resolved_incidents_by_date(resolved_incidents) do
    date_range = Date.range(Date.utc_today(), Date.add(Date.utc_today(), -7))

    date_range
    |> Enum.map(fn date -> {date, resolved_incidents_with_date(resolved_incidents, date)} end)
  end

  defp resolved_incidents_with_date(resolved_incidents, date) do
    Enum.filter(resolved_incidents, fn ri -> NaiveDateTime.to_date(ri.inserted_at) == date end)
  end

end
