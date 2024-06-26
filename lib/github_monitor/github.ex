defmodule GithubMonitor.Github do
  @moduledoc """
  The Github context.
  """

  import Ecto.Query, warn: false
  alias GithubMonitor.Repo

  alias GithubMonitor.Github.Repository

  @pub_sub_topic "repository"

  def subscribe_repository do
    Phoenix.PubSub.subscribe(GithubMonitor.PubSub, @pub_sub_topic)
  end

  def broadcast_updated_repository(repository) do
    Phoenix.PubSub.broadcast(
      GithubMonitor.PubSub,
      @pub_sub_topic,
      {:updated, repository}
    )
  end

  def broadcast_new_repository(repository) do
    Phoenix.PubSub.broadcast(
      GithubMonitor.PubSub,
      @pub_sub_topic,
      {:saved, repository}
    )
  end

  def broadcast_delete_repository(repository) do
    Phoenix.PubSub.broadcast(
      GithubMonitor.PubSub,
      @pub_sub_topic,
      {:deleted, repository}
    )
  end


  @doc """
  Returns the list of repositories.

  ## Examples

      iex> list_repositories()
      [%Repository{}, ...]

  """
  def list_repositories do
    Repo.all(Repository)
  end

  @doc """
  Gets a single repository.

  Raises `Ecto.NoResultsError` if the Repository does not exist.

  ## Examples

      iex> get_repository!(123)
      %Repository{}

      iex> get_repository!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repository!(id), do: Repo.get!(Repository, id)

  @doc """
  Creates a repository.

  ## Examples

      iex> create_repository(%{field: value})
      {:ok, %Repository{}}

      iex> create_repository(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repository(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a repository.

  ## Examples

      iex> update_repository(repository, %{field: new_value})
      {:ok, %Repository{}}

      iex> update_repository(repository, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_repository(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a repository.

  ## Examples

      iex> delete_repository(repository)
      {:ok, %Repository{}}

      iex> delete_repository(repository)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repository(%Repository{} = repository) do
    Repo.delete(repository)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repository changes.

  ## Examples

      iex> change_repository(repository)
      %Ecto.Changeset{data: %Repository{}}

  """
  def change_repository(%Repository{} = repository, attrs \\ %{}) do
    Repository.changeset(repository, attrs)
  end

  def parse_repository_name(full_name) do
    [owner_username, name] = String.split(full_name, "/")

    %{full_name: full_name, name: name, owner_username: owner_username}
  end

  def fetch_repository_information(%{name: name, owner_username: owner_username} = attrs, client) do
    # TODO: Add error handling
    {status, repo, _} = Tentacat.Repositories.repo_get(client, owner_username, name)

    attrs
    |> fill_in_repository_information(repo)
  end

  defp fill_in_repository_information(attrs, %{"html_url" => url, "description" => description}) do
    attrs
    |> Map.put(:url, url)
    |> Map.put(:description, description)
  end
end
