defmodule GigalixirServerlessBroadway.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      {GigalixirServerlessBroadway, []}
    ]

    opts = [strategy: :one_for_one, name: GigalixirServerlessBroadway.BroadwaySupervisor]
    Supervisor.start_link(children, opts)
  end
end
