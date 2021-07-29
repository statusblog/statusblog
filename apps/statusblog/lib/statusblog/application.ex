defmodule Statusblog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    setup_sentry()

    children = [
      {Finch, name: Swoosh.Finch},
      # Start the Ecto repository
      Statusblog.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Statusblog.PubSub},
      {Oban, oban_config()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Statusblog.Supervisor)
  end

  def setup_sentry() do
    Logger.add_backend(Sentry.LoggerBackend)

    :telemetry.attach_many(
      "oban-errors",
      [[:oban, :job, :exception], [:oban, :circuit, :trip]],
      &ErrorReporter.handle_event/4,
      %{}
    )
  end

  defp oban_config do
    Application.fetch_env!(:statusblog, Oban)
  end
end
