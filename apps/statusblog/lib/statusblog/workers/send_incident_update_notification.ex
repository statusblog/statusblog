defmodule Statusblog.Workers.SendIncidentUpdateNotification do
  use Oban.Worker, queue: :default

  alias Statusblog.Subscriptions

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    %{
      blog: blog,
      incident: incident,
      incident_update: incident_update,
      is_new?: is_new?,
      subscription: subscription
    } = args

    Subscriptions.deliver_email_incident_update(blog, incident, incident_update, is_new?, subscription)
  end
end
