defmodule GithubMonitor.Repo do
  use Ecto.Repo,
    otp_app: :github_monitor,
    adapter: Ecto.Adapters.Postgres
end
