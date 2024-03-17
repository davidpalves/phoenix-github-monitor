defmodule GithubMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GithubMonitorWeb.Telemetry,
      GithubMonitor.Repo,
      {DNSCluster, query: Application.get_env(:github_monitor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GithubMonitor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GithubMonitor.Finch},
      # Start a worker by calling: GithubMonitor.Worker.start_link(arg)
      # {GithubMonitor.Worker, arg},
      # Start to serve requests, typically the last entry
      GithubMonitorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GithubMonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
