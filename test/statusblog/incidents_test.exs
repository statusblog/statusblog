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

  describe "incident_updates" do
    alias Statusblog.Incidents.IncidentUpdate

    import Statusblog.IncidentsFixtures

    @invalid_attrs %{body: nil, status: nil}

    test "list_incident_updates/1 returns all incident_updates" do
      incident_update = incident_update_fixture()
      assert Incidents.list_incident_updates(incident_update.incident_id) == [incident_update]
    end

    test "get_incident_update!/1 returns the incident_update with given id" do
      incident_update = incident_update_fixture()
      assert Incidents.get_incident_update!(incident_update.id) == incident_update
    end

    test "create_incident_update/1 with valid data creates a incident_update" do
      valid_attrs = %{body: "some body", status: :investigating}

      assert {:ok, %IncidentUpdate{} = incident_update} = Incidents.create_incident_update(incident_fixture(), valid_attrs)
      assert incident_update.body == "some body"
      assert incident_update.status == :investigating
    end

    test "create_incident_update/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Incidents.create_incident_update(incident_fixture(), @invalid_attrs)
    end

    test "create_incident_update/2 with invalid enum returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Incidents.create_incident_update(incident_fixture(), %{body: "b", status: :foo})
    end

    test "update_incident_update/2 with valid data updates the incident_update" do
      incident_update = incident_update_fixture()
      update_attrs = %{body: "some updated body", status: :identified}

      assert {:ok, %IncidentUpdate{} = incident_update} = Incidents.update_incident_update(incident_update, update_attrs)
      assert incident_update.body == "some updated body"
      assert incident_update.status == :identified
    end

    test "update_incident_update/2 with invalid data returns error changeset" do
      incident_update = incident_update_fixture()
      assert {:error, %Ecto.Changeset{}} = Incidents.update_incident_update(incident_update, @invalid_attrs)
      assert incident_update == Incidents.get_incident_update!(incident_update.id)
    end

    test "delete_incident_update/1 deletes the incident_update" do
      incident_update = incident_update_fixture()
      assert {:ok, %IncidentUpdate{}} = Incidents.delete_incident_update(incident_update)
      assert_raise Ecto.NoResultsError, fn -> Incidents.get_incident_update!(incident_update.id) end
    end

    test "change_incident_update/1 returns a incident_update changeset" do
      incident_update = incident_update_fixture()
      assert %Ecto.Changeset{} = Incidents.change_incident_update(incident_update)
    end
  end
end
