defmodule Statusblog.Components do
  @moduledoc """
  The Components context.
  """

  import Ecto.Query, warn: false
  alias Statusblog.Repo

  alias Statusblog.Components.{Component, ComponentUpdate, ComponentUptime, ComponentUptimeDay}
  alias Statusblog.Blogs.Blog

  #def list_components(%Blog{id: id} = blog), do: list_components(id)
  def list_components(blog_id) do
    from(Component, where: [blog_id: ^blog_id], order_by: [asc: :position])
    |> Repo.all()
  end

  @doc """
  Gets a single component.

  Raises `Ecto.NoResultsError` if the Component does not exist.

  ## Examples

      iex> get_component!(123)
      %Component{}

      iex> get_component!(456)
      ** (Ecto.NoResultsError)

  """
  def get_component!(id), do: Repo.get!(Component, id)

  @doc """
  Creates a component.

  ## Examples

      iex> create_component(%{field: value})
      {:ok, %Component{}}

      iex> create_component(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_component(%Blog{} = blog, attrs \\ %{}) do
    position = Repo.one!(from c in Component, select: coalesce(max(c.position), 0))
    %Component{blog_id: blog.id, position: position + 1}
    |> Component.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a component.

  ## Examples

      iex> update_component(component, %{field: new_value})
      {:ok, %Component{}}

      iex> update_component(component, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_component(%Component{} = component, attrs) do
    component
    |> Component.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a component.

  ## Examples

      iex> delete_component(component)
      {:ok, %Component{}}

      iex> delete_component(component)
      {:error, %Ecto.Changeset{}}

  """
  def delete_component(%Component{} = component) do
    Repo.delete(component)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking component changes.

  ## Examples

      iex> change_component(component)
      %Ecto.Changeset{data: %Component{}}

  """
  def change_component(%Component{} = component, attrs \\ %{}) do
    component
    |> Repo.preload(:component_updates)
    |> Component.changeset(attrs)
  end

  def get_component_uptime(%Component{} = component, num_days \\ 90) do
    component = Repo.preload(component, :component_updates)
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    get_component_uptime(component.component_updates, component.start_date, num_days, now)
  end

  def get_component_uptime(updates, start_date, num_days, now) do
    days = get_component_uptime_days(updates, start_date, num_days, now)
    # total_percent = compute_uptime_percent(days)
    %ComponentUptime{days: days, total_percent: 100}
  end

  defp get_component_uptime_days(component_updates, start_date, days, now) do
    today = Timex.to_date(now)
    relevant_updates = Enum.filter(component_updates, fn cu ->
      NaiveDateTime.compare(cu.inserted_at, Timex.to_naive_datetime(start_date)) == :gt
    end)

    Enum.map(
      Date.range(Date.add(today, -(days - 1)), today),
      &get_component_uptime_day(relevant_updates, start_date, &1, now)
    )
  end

  defp get_component_uptime_day(component_updates, start_date, date, now) do
    if Date.compare(date, start_date) == :lt do
      %ComponentUptimeDay{date: date}
    else
      date_interval = Timex.Interval.new(from: date, until: Date.add(date, 1))

      # optimistically assume we will be up for rest of the day
      now_update = %ComponentUpdate{inserted_at: now, status: :operational}
      midnight = %ComponentUpdate{inserted_at: get_midnight(now)}
      complete_updates = component_updates ++ [now_update, midnight]

      {_, _, day} = Enum.reduce(
        complete_updates,
        {:operational, start_date, %ComponentUptimeDay{date: date}},
        fn (update, {status, last_time, day}) ->
          if last_time == update.inserted_at do
            {update.status, update.inserted_at, day}
          else
            cur_interval = Timex.Interval.new(from: last_time, until: update.inserted_at)

            if Timex.Interval.overlaps?(date_interval, cur_interval) do
              duration_seconds = get_duration_seconds(date_interval, cur_interval)
              duration_key = String.to_atom("#{status}_seconds")
              day = Map.update!(day, duration_key, &(&1 + duration_seconds))
              {update.status, update.inserted_at, day}
            else
              {update.status, update.inserted_at, day}
            end
          end
        end)

      day
    end
  end

  defp get_duration_seconds(date_interval, status_interval) do
    # should always be 86400, in any case. :shrug:
    date_duration = Timex.Interval.duration(date_interval, :seconds)

    case Timex.Interval.difference(date_interval, status_interval) do
      # status interval overlaps on beginning or end
      [date_interval_sans_overlap] ->
        date_duration - Timex.Interval.duration(date_interval_sans_overlap, :seconds)

      # status interval is contained entirely within the date
      [_before, _after] ->
        Timex.Interval.duration(status_interval, :seconds)

      # date is contained entirely within status interval
      [] ->
        date_duration
    end
  end

  # defp get_midnight(now) do
  #   Timex.end_of_day(now)
  # end

  defp get_midnight(now) do
    Timex.to_date(now)
    |> Date.add(1)
    |> Timex.to_naive_datetime()
  end

end
