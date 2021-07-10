defmodule Statusblog.Workers.ProcessIncidentUpdate do
  use Oban.Worker, queue: :default

  alias Statusblog.Incidents
  alias Statusblog.Subscriptions
  alias Statusblog.Workers.SendIncidentUpdateEmail

  @impl Oban.Worker
  # def perform(_job) do
  #   IO.puts "HELLO"
  #   :ok
  # end
  def perform(%Oban.Job{args: %{"incident_update_id" => incident_update_id, "is_new?" => is_new?}}) do
    incident_update = Incidents.get_incident_update!(incident_update_id)
    incident = Incidents.get_incident!(incident_update.incident_id)

    subscriptions = Subscriptions.list_subscriptions(incident.blog_id)
    for subscription <- subscriptions do
      # right now, we only have email type - when adding more, conver to case statement
      %{
        update_id: incident_update.id,
        update_status: incident_update.status,
        update_components: incident_update.components,
        is_new?: is_new?,
        incident_name: incident.name,
        incident_id: incident.id,
        subscription_id: subscription.id,
        subscription_email: subscription.email
      }
      |> IO.inspect()
      # |> SendIncidentUpdateEmail.new()
      # |> Oban.insert!()
    end

    :ok
  end
end
