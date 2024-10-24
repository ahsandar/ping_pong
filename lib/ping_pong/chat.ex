defmodule PingPong.Chat do
  @moduledoc """
    PingPong.Chat
  """
  def fireworks(body) do
    ping_or_pong = PingPong.Utility.ping_or_pong(:fireworks_chat)
    config = PingPong.Config.fireworks()[ping_or_pong]
    IO.inspect(config[:chat_api], label: "API ENDPOINT")
    IO.inspect(config[:api_key], label: "API KEY")
    PingPong.Utility.api_call(config[:chat_api], config[:api_key], body)
  end
end
