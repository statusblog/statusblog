defmodule Statusblog.EmailsTest do
  use Statusblog.DataCase

  alias Statusblog.Emails
  import Statusblog.{SubscriptionsFixtures, BlogsFixtures, ComponentsFixtures, IncidentsFixtures}

  test "subscription_confirmation_email/2" do
    email = Emails.subscription_confirmation(%{email: "a@a.com"}, "https://example.com")
    assert email.text_body =~ "a@a.com"
    assert email.text_body =~ "example.com"
  end

  test "incident_update_notification/5 is_new?" do
    blog = blog_fixture()
    incident = incident_fixture(blog)
    [incident_update] = incident.incident_updates
    subscription = subscription_fixture(blog)

    email = Emails.incident_update_notification(blog, incident, incident_update, true, subscription)
    assert email.text_body =~ subscription.email
    assert email.text_body =~ blog.name
    assert email.text_body =~ "New incident"
  end

  test "incident_update_notification/5 not new w/ components" do
    blog = blog_fixture()
    incident = incident_fixture(blog)
    incident_update = incident_update_fixture(incident, %{
      components: [
        %{id: 1, status: :operational, name: "my-comp-name"},
      ]
    })
    subscription = subscription_fixture(blog)

    email = Emails.incident_update_notification(blog, incident, incident_update, false, subscription)
    assert email.text_body =~ "my-comp-name"
    assert email.text_body =~ "Incident status"
  end
end
