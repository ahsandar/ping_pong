defmodule PingPong.Embedding do
  @moduledoc """
    PingPong.Embedding
  """
  def fireworks(body) do
    ping_or_pong = PingPong.Utility.ping_or_pong(:fireworks_embedding)
    config = PingPong.Config.fireworks()[ping_or_pong]
    IO.inspect(config[:embedding_api], label: "API ENDPOINT")
    IO.inspect(ping_or_pong, label: "API KEY")
    PingPong.Utility.api_call(config[:embedding_api], config[:api_key], body)
  end
end
