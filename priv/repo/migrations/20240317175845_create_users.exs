defmodule GithubMonitor.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
