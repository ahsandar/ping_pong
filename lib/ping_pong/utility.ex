defmodule PingPong.Utility do
  @moduledoc """
    PingPong.Utility
  """
  require Integer

  def ping_or_pong(key) do
    case Cachex.get(:ping_pong, key) do
      {:ok, nil} ->
        Cachex.put(:ping_pong, key, 0)
        :ping

      {:ok, val} ->
        Cachex.incr(:ping_pong, key)
        if Integer.is_even(val), do: :pong, else: :ping
    end
  end

  def api_call(endpoint, key, body) do
    response = Req.post!(endpoint, auth: {:bearer, key}, json: body)
    {response.status, response.body}
  end
end
