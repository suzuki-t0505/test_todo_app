defmodule TestTodoAppWeb.PageController do
  use TestTodoAppWeb, :controller

  alias TestTodoApp.Accounts

  def home(conn, _params) do
    current_account =
      if token = get_session(conn, "account_token") do
        Accounts.get_account_by_session_token(token)
      end

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, current_account: current_account)
  end
end
