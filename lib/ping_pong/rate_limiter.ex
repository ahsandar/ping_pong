defmodule PingPong.RateLimiter do
  use GenServer
  require Logger

  alias PingPong.Utility, as: Utility
  @rate_limit_window 60_000
  @cachex_counter "request_counter"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: :rate_limiter)
  end

  def init(_config) do
    Cachex.put(:ping_pong, @cachex_counter, 0)

    {:ok,
     %{
       start_time: Utility.datetime_iso8601(),
       rate_limit: String.to_integer(System.get_env("FIREWORKS_RATE_LIMIT") || "60")
     }}
  end

  def handle_call(:control_rate_limit, _from, state) do
    sleep_time = @rate_limit_window / state.rate_limit |> trunc()
    Logger.info("Ensuring rate limit at #{Utility.datetime_iso8601()}, waiting for #{sleep_time}")
    :timer.sleep(sleep_time)
    {_, count} = Cachex.incr(:ping_pong, @cachex_counter)
    Logger.info("Count since #{state.start_time}: #{count}")
    {:reply, "Done", state}
  end

  def queue() do
    GenServer.call(:rate_limiter, :control_rate_limit)
  end
end
