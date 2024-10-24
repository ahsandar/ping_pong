defmodule PingPong.Embedding do
  @moduledoc """
    PingPong.Embedding
  """
  require Logger

  alias PingPong.Utility, as: Utility
  alias PingPong.Config, as: Config

  def fireworks(body) do
    ping_or_pong = Utility.ping_or_pong(:fireworks_embedding)
    config = Config.fireworks(ping_or_pong)
    Logger.info(config[:embedding_api])
    Logger.info("#{ping_or_pong}")

    {_, response} =
      Utility.api_call(config[:embedding_api], config[:api_key], body)

    response
  end
end
