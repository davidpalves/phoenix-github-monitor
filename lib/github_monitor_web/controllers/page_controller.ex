defmodule GithubMonitorWeb.PageController do
  use GithubMonitorWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    # TODO: delete this later, just for debugging
    IO.inspect(conn.assigns.current_user)
    client = Tentacat.Client.new(%{access_token: conn.assigns.current_user.token})
    IO.inspect(Tentacat.Users.me(client))

    render(conn, :home, layout: false)
  end
end
