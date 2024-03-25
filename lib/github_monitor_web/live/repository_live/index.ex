defmodule GithubMonitorWeb.RepositoryLive.Index do
  use GithubMonitorWeb, :live_view

  alias GithubMonitor.Github
  alias GithubMonitor.Accounts
  alias GithubMonitor.Github.Repository

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket), do: Github.subscribe_repository()

    user = Accounts.get_user(user_id)

    updated_repos = Github.list_repositories()
    {:ok,
     socket
     |> assign(:repositories, updated_repos)
     |> assign(:current_user, user)
    }
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

  def handle_info({:updated, _}, socket) do
    updated_urls = Github.list_repositories()

    {:noreply, assign(socket, :urls, updated_urls)}
  end

  def handle_info({:saved, repository}, socket) do
    updated_repositories = [socket.assigns.repositories | repository]

    {:noreply, assign(socket, :repositories, updated_repositories)}
  end

  def handle_info({:deleted, repository}, socket) do
    updated_repositories =
      socket.assigns.repositories
      |> Enum.reject(fn repo ->
        repo.id == repository.id
      end)

    {:noreply, assign(socket, :repositories, updated_repositories)}
  end

  @impl true
  def handle_info({GithubMonitorWeb.RepositoryLive.FormComponent, {:saved, _repository}}, socket) do
    updated_repos = Github.list_repositories()

    {:noreply, assign(socket, :repositories, updated_repos)}
  end

  @impl true
  def handle_info({GithubMonitorWeb.RepositoryLive.FormComponent, {:deleted, repository}}, socket) do
    updated_repos = Github.list_repositories()

    {:noreply,
    socket
    |> put_flash(:info, "Repository #{repository.full_name} has been removed")
    |> assign(:urls, updated_repos)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    repository = Github.get_repository!(id)
    {:ok, _} = Github.delete_repository(repository)

    Github.broadcast_delete_repository(repository)

    updated_repositories =
      socket.assigns.repositories
      |> Enum.reject(fn repo ->
        repo.id == repository.id
      end)

    {:noreply,
    socket
    |> put_flash(:info, "Repository #{repository.full_name} has been removed")
    |> assign(:repositories, updated_repositories)}
  end
end
