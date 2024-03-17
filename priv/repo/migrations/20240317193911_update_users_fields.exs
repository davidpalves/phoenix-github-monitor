defmodule GithubMonitor.Repo.Migrations.UpdateUsersFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :nickname, :string
    end
  end
end
