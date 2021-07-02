defmodule Statusblog.Components.ComponentUptimeDay do
  defstruct [
    :date,
    operational_seconds: 0,
    under_maintenance_seconds: 0,
    degraded_performance_seconds: 0,
    partial_outage_seconds: 0,
    major_outage_seconds: 0
  ]
end
