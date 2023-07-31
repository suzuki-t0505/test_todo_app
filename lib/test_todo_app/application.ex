defmodule TestTodoApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TestTodoAppWeb.Telemetry,
      # Start the Ecto repository
      TestTodoApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TestTodoApp.PubSub},
      # Start Finch
      {Finch, name: TestTodoApp.Finch},
      # Start the Endpoint (http/https)
      TestTodoAppWeb.Endpoint
      # Start a worker by calling: TestTodoApp.Worker.start_link(arg)
      # {TestTodoApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TestTodoApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TestTodoAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
