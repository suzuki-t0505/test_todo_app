defmodule TestTodoApp.Repo do
  use Ecto.Repo,
    otp_app: :test_todo_app,
    adapter: Ecto.Adapters.Postgres
end
