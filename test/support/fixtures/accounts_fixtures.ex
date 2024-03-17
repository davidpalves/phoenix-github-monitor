defmodule GithubMonitor.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GithubMonitor.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> GithubMonitor.Accounts.create_user()

    user
  end
end
