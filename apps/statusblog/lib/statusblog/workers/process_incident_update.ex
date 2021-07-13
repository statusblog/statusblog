defmodule Statusblog.Workers.ProcessIncidentUpdate do
  use Oban.Worker, queue: :default

  alias Statusblog.Incidents
  alias Statusblog.Subscriptions
  alias Statusblog.Workers.SendIncidentUpdateNotification

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"incident_update_id" => incident_update_id, "is_new?" => is_new?}}) do
    incident_update = Incidents.get_incident_update!(incident_update_id)
    incident = Incidents.get_incident!(incident_update.incident_id)
    subscriptions = Subscriptions.list_subscriptions(incident.blog_id)

    for subscription <- subscriptions do
      %{
        incident_update_id: incident_update_id,
        incident_id: incident.id,
        blog_id: incident.blog_id,
        subscription_id: subscription.id,
        is_new?: is_new?
      }
      |> SendIncidentUpdateNotification.new()
      |> Oban.insert!()
    end

    :ok
  end
end
