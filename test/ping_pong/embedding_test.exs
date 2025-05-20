defmodule PingPong.EmbeddingTest do
  use ExUnit.Case
  doctest PingPong.Embedding

  import Mock

  setup do
    Cachex.clear(PingPong.Utility.cachex())
    :ok
  end

  test "fireworks makes API call with correct parameters" do
    test_body = %{"model" => "test_model", "input" => "test input"}
    
    with_mock PingPong.Utility, [
      api_call: fn _endpoint, _key, _body, _rate_limiter -> {:ok, {200, %{embeddings: [1.0, 2.0]}}} end,
      ping_or_pong: fn _key -> :ping end
    ] do
      {status, response} = PingPong.Embedding.fireworks(test_body)
      assert status == 200
      assert response.embeddings == [1.0, 2.0]
    end
  end
end