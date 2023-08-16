defmodule Xeni.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      XeniWeb.Telemetry,
      # Start the Ecto repository
      Xeni.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Xeni.PubSub},
      # Start Finch
      {Finch, name: Xeni.Finch},
      # Start the Endpoint (http/https)
      XeniWeb.Endpoint
      # Start a worker by calling: Xeni.Worker.start_link(arg)
      # {Xeni.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Xeni.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XeniWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
