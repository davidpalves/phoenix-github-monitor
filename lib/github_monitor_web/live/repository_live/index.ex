defmodule GithubMonitorWeb.RepositoryLive.Index do
  use GithubMonitorWeb, :live_view

  alias GithubMonitor.Github
  alias GithubMonitor.Github.Repository

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :repositories, Github.list_repositories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Repository")
    |> assign(:repository, Github.get_repository!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Repository")
    |> assign(:repository, %Repository{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Repositories")
    |> assign(:repository, nil)
  end

  @impl true
  def handle_info({GithubMonitorWeb.RepositoryLive.FormComponent, {:saved, repository}}, socket) do
    {:noreply, stream_insert(socket, :repositories, repository)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    repository = Github.get_repository!(id)
    {:ok, _} = Github.delete_repository(repository)

    {:noreply, stream_delete(socket, :repositories, repository)}
  end
end
