defmodule GithubMonitor.GithubFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GithubMonitor.Github` context.
  """

  @doc """
  Generate a repository.
  """
  def repository_fixture(attrs \\ %{}) do
    {:ok, repository} =
      attrs
      |> Enum.into(%{
        description: "some description",
        full_name: "some full_name",
        name: "some name",
        owner_username: "some owner_username",
        url: "some url"
      })
      |> GithubMonitor.Github.create_repository()

    repository
  end
end
