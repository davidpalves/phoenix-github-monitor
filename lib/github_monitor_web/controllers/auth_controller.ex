defmodule GithubMonitorWeb.AuthController do
  use GithubMonitorWeb, :controller

  plug Ueberauth

  alias GithubMonitor.Accounts

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_data = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: Atom.to_string(auth.provider),
      name: auth.info.name,
      nickname: auth.info.nickname
    }

    case Accounts.find_or_create(user_data) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to your Github Monitor!")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
