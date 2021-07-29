defmodule Statusblog.Workers.SendIncidentUpdateNotification do
  use Oban.Worker, queue: :default

  alias Statusblog.Blogs
  alias Statusblog.Incidents
  alias Statusblog.Subscriptions

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    %{
      "blog_id" => blog_id,
      "incident_id" => incident_id,
      "incident_update_id" => incident_update_id,
      "is_new?" => is_new?,
      "subscription_id" => subscription_id
    } = args

    blog = Blogs.get_blog!(blog_id)
    incident = Incidents.get_incident!(incident_id)
    incident_update = Incidents.get_incident_update!(incident_update_id)
    subscription = Subscriptions.get_subscription!(subscription_id)

    Statusblog.Emails.incident_update_notification(
      blog,
      incident,
      incident_update,
      is_new?,
      subscription
    )
    |> Statusblog.Mailer.deliver_better()
  end
end
