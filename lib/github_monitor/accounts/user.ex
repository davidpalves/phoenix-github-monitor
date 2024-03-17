defmodule GithubMonitor.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :token, :string
    field :provider, :string
    field :email, :string
    field :name, :string
    field :nickname, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token, :name, :nickname])
    |> validate_required([:email, :provider, :token, :nickname])
    |> unique_constraint(:email)
  end
end
