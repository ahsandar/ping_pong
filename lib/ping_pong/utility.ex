defmodule PingPong.Utility do
  @moduledoc """
    PingPong.Utility
  """
  require Integer

  use Retry.Annotation

  alias PingPong.RateLimiter, as: RateLimiter

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
  def api_call(endpoint, key, body, rate_limiter \\ :fireworks_rate_limit, timeout \\ 45_000) do
    Cachex.incr(:ping_pong, cachex_counter())
    RateLimiter.queue(rate_limiter, timeout)
    response = Req.post!(endpoint, auth: {:bearer, key}, json: body)

    cond do
      response.status > 410 -> {:error, {response.status, response.body}}
      true -> {:ok, {response.status, response.body}}
    end
  end

  def datetime_iso8601() do
    DateTime.utc_now() |> DateTime.to_iso8601()
  end

  def cachex_counter(), do: "request_counter"
end
