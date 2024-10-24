defmodule PingPong.Utility do
  @moduledoc """
    PingPong.Utility
  """
  require Integer

  use Retry.Annotation

  def cachex() do
    :ping_pong
  end

  def ping_or_pong(key) do
    case Cachex.get(cachex(), key) do
      {:ok, nil} ->
        Cachex.put(cachex(), key, 0)
        :ping

      {:ok, val} ->
        Cachex.incr(cachex(), key)
        if Integer.is_even(val), do: :pong, else: :ping
    end
  end

  @retry with: constant_backoff(100) |> Stream.take(1)
  def api_call(endpoint, key, body) do
    response = Req.post!(endpoint, auth: {:bearer, key}, json: body)

    cond do
      response.status > 499 -> {:error, {response.status, response.body}}
      true -> {:ok, {response.status, response.body}}
    end
  end
end
