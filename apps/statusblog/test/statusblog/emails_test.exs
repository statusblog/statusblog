defmodule Statusblog.EmailsTest do
  use Statusblog.DataCase

  alias Statusblog.Emails
  import Statusblog.{SubscriptionsFixtures, BlogsFixtures, ComponentsFixtures, IncidentsFixtures}

  test "subscription_confirmation_email/2" do
    email = Emails.subscription_confirmation(%{email: "a@a.com"}, "https://example.com")
    assert email.text_body =~ "a@a.com"
    assert email.text_body =~ "example.com"
  end
end
