defmodule TestTodoAppWeb.TodoLive do
  use TestTodoAppWeb, :live_view

  alias TestTodoApp.Tasks
  alias TestTodoApp.Tasks.Task

  def render(assigns) do
    ~H"""
    <.header>Your Todo</.header>

    <.simple_form for={@form} phx-change="validate_task" phx-submit="save_task" class="border rounded-lg px-4 py-2">
      <.input field={@form[:title]} type="text" label="Title" />
      <.input field={@form[:date]} type="date" label="Date" />
      <:actions>
        <.button phx-disabled-with="Adding...">Add Task</.button>
      </:actions>
    </.simple_form>

    <div class="mt-2">
      <div class="border rounded-lg px-4 py-2 my-2">
        <h2 class="text-xl">In progress or prior to start</h2>
        <dl class="mt-2">
          <div :for={task <- @tasks} class="flex justify-between py-2 border-b last:border-b-0">
            <dt class="flex items-center w-1/3">
              <form phx-change="completed_task">
                <input type="checkbox" checked={task.completed} class="block" />
                <input type="hidden" name="task_id" value={task.id} />
              </form>
              <div class="ml-2">
                <%= task.title %>
              </div>
            </dt>
            <dd class="w-1/3 text-center"><%= task.date %></dd>
            <dd class="w-1/3 text-center">
              <span phx-click="delete_task" phx-value-task_id={task.id} class="hover:underline cursor-pointer">
                Delete
              </span>
            </dd>
          </div>
        </dl>
      </div>

      <div class="border rounded-lg px-4 py-2 my-2">
        <h2 class="text-xl">Completed</h2>
        <dl class="mt-2">
          <div :for={task <- @completed_tasks} class="flex justify-between py-2 border-b last:border-b-0">
            <dt class="flex items-center w-1/3">
              <form phx-change="completed_task">
                <input type="checkbox" checked={task.completed} class="block" />
                <input type="hidden" name="task_id" value={task.id} />
              </form>
              <div class="ml-2">
                <%= task.title %>
              </div>
            </dt>
            <dd class="w-1/3 text-center"><%= task.date %></dd>
            <dd class="w-1/3 text-center">
              <span phx-click="delete_task" phx-value-task_id={task.id} class="hover:underline cursor-pointer">
                Delete
              </span>
            </dd>
          </div>
        </dl>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:tasks, Tasks.list_tasks(socket.assigns.current_account.id))
      |> assign(:completed_tasks, Tasks.list_completed_tasks(socket.assigns.current_account.id))
      |> assign_form(Tasks.change_task(%Task{}))
      |> assign(:page_title, "Todo")

    {:ok, socket}
  end

  def handle_event("validate_task", %{"task" => params}, socket) do
    {:noreply, assign_form(socket, Tasks.change_task(%Task{}, params))}
  end

  def handle_event("save_task", %{"task" => params}, socket) do
    params = Map.merge(params, %{"account_id" => socket.assigns.current_account.id})
    socket =
      case Tasks.create_task(params) do
        {:ok, _task} ->
          socket
          |> put_flash(:info, "Created task successfully.")
          |> assign(:tasks, Tasks.list_tasks(socket.assigns.current_account.id))
          |> assign_form(Tasks.change_task(%Task{}))

        {:error, cs} ->
          assign_form(socket, cs)
      end

    {:noreply, socket}
  end

  def handle_event("completed_task", %{"task_id" => task_id}, socket) do
    task = Tasks.get_task!(task_id)
    socket =
      case Tasks.update_task(task, %{"completed" => !task.completed}) do
        {:ok, update_task} ->
          socket
          |> assign(:tasks, Tasks.list_tasks(socket.assigns.current_account.id))
          |> assign(:completed_tasks, Tasks.list_completed_tasks(socket.assigns.current_account.id))
          |> put_flash(:info, "Updated task successfully.")

        {:error, _cs} ->
          put_flash(socket, :error, "Updated task failed.")
      end

    {:noreply, socket}
  end

  def handle_event("delete_task", %{"task_id" => task_id}, socket) do
    task = Tasks.get_task!(task_id)

    socket =
      case Tasks.delete_task(task) do
        {:ok, _task} ->
          socket
          socket
          |> assign(:tasks, Tasks.list_tasks(socket.assigns.current_account.id))
          |> assign(:completed_tasks, Tasks.list_completed_tasks(socket.assigns.current_account.id))
          |> put_flash(:info, "Deleted task successfully.")

        {:error, _cs} ->
          put_flash(socket, :error, "Deleted task failed.")
      end

    {:noreply, socket}
  end

  defp assign_form(socket, cs) do
    assign(socket, :form, to_form(cs))
  end
end
