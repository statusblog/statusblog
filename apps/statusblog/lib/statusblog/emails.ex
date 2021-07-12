defmodule Statusblog.Emails do
  require EEx
  import Swoosh.Email
  import Statusblog.Emails.Macros

  text_template(:subscription_confirmation, [:subscription, :url])
  text_template(:incident_update_notification, [:blog, :incident, :incident_update, :is_new?, :subscription])

  defp test(), do: "test"

  def subscription_confirmation(subscription, url) do
    new()
    |> to(subscription.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    # todo: could prefix with [blog_name]
    |> subject("Confirm your email")
    |> text_body(subscription_confirmation_txt(subscription, url))
  end

  def incident_update_notification(blog, incident, incident_update, is_new?, subscription) do
    new()
    |> to(subscription.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    # todo: could prefix with [blog_name]
    |> subject("[#{blog.name}] Incident - #{incident.name}")
    |> text_body(incident_update_notification(blog, incident, incident_update, is_new?, subscription))
  end

end
