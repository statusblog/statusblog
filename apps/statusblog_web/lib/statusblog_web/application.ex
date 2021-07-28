defmodule StatusblogWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Logger.add_backend(Sentry.LoggerBackend)

    children = [
      # Start the Telemetry supervisor
      StatusblogWeb.Telemetry,
      # Start the Endpoint (http/https)
      StatusblogWeb.Endpoint
      # Start a worker by calling: StatusblogWeb.Worker.start_link(arg)
      # {StatusblogWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StatusblogWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StatusblogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
