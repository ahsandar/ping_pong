defmodule PingPong.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: PingPong.Worker.start_link(arg)
      # {PingPong.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: PingPong.Endpoint,
        options: [port: 4001]
      ),
      {Cachex, name: :ping_pong}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PingPong.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
