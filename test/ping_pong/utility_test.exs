defmodule PingPong.UtilityTest do
  use ExUnit.Case
  doctest PingPong.Utility

  setup do
    Cachex.clear(PingPong.Utility.cachex())
    :ok
  end

  test "ping_or_pong returns :ping for first call" do
    assert PingPong.Utility.ping_or_pong(:test_key) == :ping
  end

  test "ping_or_pong alternates between :ping and :pong" do
    assert PingPong.Utility.ping_or_pong(:test_key2) == :ping
    assert PingPong.Utility.ping_or_pong(:test_key2) == :pong
    assert PingPong.Utility.ping_or_pong(:test_key2) == :ping
  end

  test "cachex_counter returns correct string" do
    assert PingPong.Utility.cachex_counter() == "request_counter"
  end

  test "datetime_iso8601 returns valid ISO8601 string" do
    datetime = PingPong.Utility.datetime_iso8601()
    {:ok, _, _} = DateTime.from_iso8601(datetime)
  end
end