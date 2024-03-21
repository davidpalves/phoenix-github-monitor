defmodule GithubMonitor.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :full_name, :string
      add :name, :string
      add :description, :string
      add :owner_username, :string
      add :url, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:repositories, [:full_name])
    create unique_index(:repositories, [:full_name, :user_id])
  end
end
