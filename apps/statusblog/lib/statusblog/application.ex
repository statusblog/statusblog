defmodule Statusblog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Statusblog.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Statusblog.PubSub}
      # Start a worker by calling: Statusblog.Worker.start_link(arg)
      # {Statusblog.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Statusblog.Supervisor)
  end
end
