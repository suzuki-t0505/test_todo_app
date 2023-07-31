defmodule TestTodoApp.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias TestTodoApp.Accounts.Account

  schema "tasks" do
    field :completed, :boolean, default: false
    field :date, :date
    field :memo, :string
    field :title, :string
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :memo, :date, :completed, :account_id])
    |> validate_required([:title, :memo, :date, :completed])
  end
end
