defmodule PingPong.Embedding do
  @moduledoc """
    PingPong.Embedding
  """
  require Logger

  def fireworks(body) do
    ping_or_pong = PingPong.Utility.ping_or_pong(:fireworks_embedding)
    config = PingPong.Config.fireworks()[ping_or_pong]
    Logger.info(config[:embedding_api])
    Logger.info("#{ping_or_pong}")
    PingPong.Utility.api_call(config[:embedding_api], config[:api_key], body)
  end
end
