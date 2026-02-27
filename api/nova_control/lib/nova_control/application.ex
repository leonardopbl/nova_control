defmodule NovaControl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NovaControlWeb.Telemetry,
      NovaControl.Repo,
      {DNSCluster, query: Application.get_env(:nova_control, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NovaControl.PubSub},
      # Start a worker by calling: NovaControl.Worker.start_link(arg)
      # {NovaControl.Worker, arg},
      # Start to serve requests, typically the last entry
      NovaControlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NovaControl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NovaControlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
