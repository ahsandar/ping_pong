defmodule PingPong.Chat do
  @moduledoc """
    PingPong.Chat
  """
  require Logger

  def fireworks(body) do
    ping_or_pong = PingPong.Utility.ping_or_pong(:fireworks_chat)
    config = PingPong.Config.fireworks()[ping_or_pong]
    Logger.info(config[:chat_api])
    Logger.info("#{ping_or_pong}")
    PingPong.Utility.api_call(config[:chat_api], config[:api_key], body)
  end
end
