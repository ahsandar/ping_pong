defmodule PingPong.ConfigTest do
  use ExUnit.Case
  doctest PingPong.Config

  setup do
    System.put_env("FIREWORKS_PING_EMBEDDING_API", "ping_embedding_api")
    System.put_env("FIREWORKS_PING_CHAT_API", "ping_chat_api")
    System.put_env("FIREWORKS_PING_API_KEY", "ping_api_key")
    System.put_env("FIREWORKS_PONG_EMBEDDING_API", "pong_embedding_api")
    System.put_env("FIREWORKS_PONG_CHAT_API", "pong_chat_api")
    System.put_env("FIREWORKS_PONG_API_KEY", "pong_api_key")
    :ok
  end

  test "returns complete config when no key provided" do
    config = PingPong.Config.fireworks()
    assert config.ping.embedding_api == "ping_embedding_api"
    assert config.ping.chat_api == "ping_chat_api"
    assert config.ping.api_key == "ping_api_key"
    assert config.pong.embedding_api == "pong_embedding_api"
    assert config.pong.chat_api == "pong_chat_api"
    assert config.pong.api_key == "pong_api_key"
  end

  test "returns specific config when key provided" do
    ping_config = PingPong.Config.fireworks(:ping)
    assert ping_config.embedding_api == "ping_embedding_api"
    assert ping_config.chat_api == "ping_chat_api"
    assert ping_config.api_key == "ping_api_key"
  end
end