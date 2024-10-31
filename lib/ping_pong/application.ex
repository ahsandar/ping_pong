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
      {Cachex, name: PingPong.Utility.cachex()},
      Supervisor.child_spec(
        {PingPong.RateLimiter,
         %{
           name: :fireworks_rate_limiter_chat,
           rate_limit: System.get_env("FIREWORKS_RATE_LIMIT_CHAT")
         }},
        id: :fireworks_rate_limiter_chat
      ),
      Supervisor.child_spec(
        {PingPong.RateLimiter,
         %{
           name: :fireworks_rate_limiter_embedding,
           rate_limit: System.get_env("FIREWORKS_RATE_LIMIT_EMBEDDING")
         }},
        id: :fireworks_rate_limiter_embedding
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PingPong.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
