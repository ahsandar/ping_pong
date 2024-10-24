defmodule PingPong.Config do
  def fireworks do
    %{
      ping: %{
        embedding_api: System.get_env("FIREWORKS_PING_EMBEDDING_API"),
        chat_api: System.get_env("FIREWORKS_PING_CHAT_API"),
        api_key: System.get_env("FIREWORKS_PING_API_KEY")
      },
      pong: %{
        embedding_api: System.get_env("FIREWORKS_PONG_EMBEDDING_API"),
        chat_api: System.get_env("FIREWORKS_PONG_CHAT_API"),
        api_key: System.get_env("FIREWORKS_PONG_API_KEY")
      }
    }
  end
end
