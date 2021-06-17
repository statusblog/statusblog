defmodule Statusblog.IncidentsTest do
  use Statusblog.DataCase

  alias Statusblog.Incidents

  describe "incidents" do
    alias Statusblog.Incidents.Incident

    import Statusblog.BlogsFixtures
    import Statusblog.IncidentsFixtures

    @invalid_attrs %{name: nil}

    test "list_incidents/1 returns all incidents" do
      incident = incident_fixture()
      assert Incidents.list_incidents(incident.blog_id) == [incident]
    end

    test "get_incident!/1 returns the incident with given id" do
      incident = incident_fixture()
      assert Incidents.get_incident!(incident.id) == incident
    end

    test "create_incident/1 with valid data creates a incident" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Incident{} = incident} = Incidents.create_incident(blog_fixture(), valid_attrs)
      assert incident.name == "some name"
    end

    test "create_incident/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Incidents.create_incident(blog_fixture(), @invalid_attrs)
    end

    test "update_incident/2 with valid data updates the incident" do
      incident = incident_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Incident{} = incident} = Incidents.update_incident(incident, update_attrs)
      assert incident.name == "some updated name"
    end

    test "update_incident/2 with invalid data returns error changeset" do
      incident = incident_fixture()
      assert {:error, %Ecto.Changeset{}} = Incidents.update_incident(incident, @invalid_attrs)
      assert incident == Incidents.get_incident!(incident.id)
    end

    test "delete_incident/1 deletes the incident" do
      incident = incident_fixture()
      assert {:ok, %Incident{}} = Incidents.delete_incident(incident)
      assert_raise Ecto.NoResultsError, fn -> Incidents.get_incident!(incident.id) end
    end

    test "change_incident/1 returns a incident changeset" do
      incident = incident_fixture()
      assert %Ecto.Changeset{} = Incidents.change_incident(incident)
    end
  end
end
