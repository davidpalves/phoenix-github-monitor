defmodule GithubMonitorWeb.RepositoryLiveTest do
  use GithubMonitorWeb.ConnCase

  import Phoenix.LiveViewTest
  import GithubMonitor.GithubFixtures

  @create_attrs %{name: "some name", description: "some description", url: "some url", full_name: "some full_name", owner_username: "some owner_username"}
  @update_attrs %{name: "some updated name", description: "some updated description", url: "some updated url", full_name: "some updated full_name", owner_username: "some updated owner_username"}
  @invalid_attrs %{name: nil, description: nil, url: nil, full_name: nil, owner_username: nil}

  defp create_repository(_) do
    repository = repository_fixture()
    %{repository: repository}
  end

  describe "Index" do
    setup [:create_repository]

    test "lists all repositories", %{conn: conn, repository: repository} do
      {:ok, _index_live, html} = live(conn, ~p"/repositories")

      assert html =~ "Listing Repositories"
      assert html =~ repository.name
    end

    test "saves new repository", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/repositories")

      assert index_live |> element("a", "New Repository") |> render_click() =~
               "New Repository"

      assert_patch(index_live, ~p"/repositories/new")

      assert index_live
             |> form("#repository-form", repository: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#repository-form", repository: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/repositories")

      html = render(index_live)
      assert html =~ "Repository created successfully"
      assert html =~ "some name"
    end

    test "updates repository in listing", %{conn: conn, repository: repository} do
      {:ok, index_live, _html} = live(conn, ~p"/repositories")

      assert index_live |> element("#repositories-#{repository.id} a", "Edit") |> render_click() =~
               "Edit Repository"

      assert_patch(index_live, ~p"/repositories/#{repository}/edit")

      assert index_live
             |> form("#repository-form", repository: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#repository-form", repository: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/repositories")

      html = render(index_live)
      assert html =~ "Repository updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes repository in listing", %{conn: conn, repository: repository} do
      {:ok, index_live, _html} = live(conn, ~p"/repositories")

      assert index_live |> element("#repositories-#{repository.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#repositories-#{repository.id}")
    end
  end

  describe "Show" do
    setup [:create_repository]

    test "displays repository", %{conn: conn, repository: repository} do
      {:ok, _show_live, html} = live(conn, ~p"/repositories/#{repository}")

      assert html =~ "Show Repository"
      assert html =~ repository.name
    end

    test "updates repository within modal", %{conn: conn, repository: repository} do
      {:ok, show_live, _html} = live(conn, ~p"/repositories/#{repository}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Repository"

      assert_patch(show_live, ~p"/repositories/#{repository}/show/edit")

      assert show_live
             |> form("#repository-form", repository: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#repository-form", repository: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/repositories/#{repository}")

      html = render(show_live)
      assert html =~ "Repository updated successfully"
      assert html =~ "some updated name"
    end
  end
end
