defmodule TestTodoApp.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TestTodoApp.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        date: ~D[2023-07-30],
        memo: "some memo",
        title: "some title"
      })
      |> TestTodoApp.Tasks.create_task()

    task
  end
end
