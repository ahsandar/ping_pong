defmodule PingPong.Chat do
  @moduledoc """
    PingPong.Chat
  """
  require Logger

  alias PingPong.Utility, as: Utility
  alias PingPong.Config, as: Config

  def fireworks(body) do
    ping_or_pong = Utility.ping_or_pong(:fireworks_chat)
    config = Config.fireworks(ping_or_pong)
    Logger.info(config[:chat_api])
    Logger.info("#{ping_or_pong}")

    {_, response} =
      Utility.api_call(config[:chat_api], config[:api_key], body, :fireworks_rate_limiter_chat)

    response
  end
end
