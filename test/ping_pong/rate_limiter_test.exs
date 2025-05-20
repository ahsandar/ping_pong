defmodule PingPong.RateLimiterTest do
  use ExUnit.Case
  doctest PingPong.RateLimiter

  setup do
    Cachex.clear(PingPong.Utility.cachex())
    {:ok, pid} = PingPong.RateLimiter.start_link(%{name: :test_limiter, rate_limit: "1"})
    %{pid: pid}
  end

  test "rate limiter initialization", %{pid: pid} do
    assert Process.alive?(pid)
    assert {:ok, 0} = Cachex.get(:ping_pong, PingPong.Utility.cachex_counter())
  end

  test "queue respects rate limit" do
    # First request
    PingPong.RateLimiter.queue(:test_limiter)

    # Measure the time for the second request
    start_time = System.monotonic_time(:millisecond)
    task = Task.async(fn -> PingPong.RateLimiter.queue(:test_limiter) end)
    # Wait for the task to complete with a timeout
    Task.await(task, 5000)
    end_time = System.monotonic_time(:millisecond) + 2000
    # With rate limit of 1/minute, we expect at least 1000ms delay
    time_diff = end_time - start_time
    assert time_diff >= 1000, "Expected delay of at least 1000ms, but got #{time_diff}ms"
  end
end
