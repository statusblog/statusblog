defmodule Statusblog.Emails do
  require EEx
  import Swoosh.Email
  import Statusblog.Emails.Macros
  alias Statusblog.Blogs.Blog

  text_template(:subscription_confirmation, [:subscription, :blog])

  text_template(:incident_update_notification, [
    :blog,
    :incident,
    :incident_update,
    :is_new?,
    :subscription
  ])

  defp site_url(%Blog{} = blog, path \\ nil) do
    origin = Statusblog.Utils.site_origin_uri(blog)

    %{origin | path: path}
    |> URI.to_string()
  end

  def subscription_confirmation(subscription, blog) do
    new()
    |> to(subscription.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    # todo: could prefix with [blog_name]
    |> subject("Confirm your email")
    |> text_body(subscription_confirmation_txt(subscription, blog))
  end

  def incident_update_notification(blog, incident, incident_update, is_new?, subscription) do
    new()
    |> to(subscription.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    # todo: could prefix with [blog_name]
    |> subject("[#{blog.name}] Incident - #{incident.name}")
    |> text_body(
      incident_update_notification_txt(blog, incident, incident_update, is_new?, subscription)
    )
  end
end
