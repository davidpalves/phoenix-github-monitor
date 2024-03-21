defmodule GithubMonitor.GithubTest do
  use GithubMonitor.DataCase

  alias GithubMonitor.Github

  describe "repositories" do
    alias GithubMonitor.Github.Repository

    import GithubMonitor.GithubFixtures

    @invalid_attrs %{name: nil, description: nil, url: nil, full_name: nil, owner_username: nil}

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Github.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Github.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      valid_attrs = %{name: "some name", description: "some description", url: "some url", full_name: "some full_name", owner_username: "some owner_username"}

      assert {:ok, %Repository{} = repository} = Github.create_repository(valid_attrs)
      assert repository.name == "some name"
      assert repository.description == "some description"
      assert repository.url == "some url"
      assert repository.full_name == "some full_name"
      assert repository.owner_username == "some owner_username"
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Github.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", url: "some updated url", full_name: "some updated full_name", owner_username: "some updated owner_username"}

      assert {:ok, %Repository{} = repository} = Github.update_repository(repository, update_attrs)
      assert repository.name == "some updated name"
      assert repository.description == "some updated description"
      assert repository.url == "some updated url"
      assert repository.full_name == "some updated full_name"
      assert repository.owner_username == "some updated owner_username"
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Github.update_repository(repository, @invalid_attrs)
      assert repository == Github.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Github.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Github.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Github.change_repository(repository)
    end
  end
end
