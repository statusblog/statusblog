defmodule StatusblogWeb.IncidentLive.UpdateInputsComponent do
  use StatusblogWeb, :live_component
  alias Statusblog.Components.Component
  alias Statusblog.Incidents.IncidentUpdate

  defp component_status_options() do
    Ecto.Enum.values(Component, :status)
    |> Enum.map(&({status_option_display(&1), &1}))
  end

  defp status_options() do
    Ecto.Enum.values(IncidentUpdate, :status)
    |> Enum.map(&({status_option_display(&1), &1}))
  end

  defp status_option_display(status) do
    status
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
