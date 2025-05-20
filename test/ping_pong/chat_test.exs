defmodule PingPong.ChatTest do
  use ExUnit.Case
  doctest PingPong.Chat

  import Mock

  setup do
    Cachex.clear(PingPong.Utility.cachex())
    :ok
  end

  test "fireworks makes API call with correct parameters" do
    test_body = %{"model" => "test_model", "messages" => []}

    with_mock PingPong.Utility,
      api_call: fn _endpoint, _key, _body, _rate_limiter ->
        {:ok, {200, %{response: "success"}}}
      end,
      ping_or_pong: fn _key -> :ping end do
      {status, response} = PingPong.Chat.fireworks(test_body)
      assert status == 200
      assert response.response == "success"
    end
  end
end
