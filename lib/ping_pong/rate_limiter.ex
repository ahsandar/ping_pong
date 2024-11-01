defmodule PingPong.RateLimiter do
  use GenServer
  require Logger

  alias PingPong.Utility, as: Utility
  @rate_limit_window 60_000
  @safe_limit 1

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  def init(config) do
    Cachex.put(:ping_pong, Utility.cachex_counter(), 0)

    {:ok,
     %{
       name: config[:name],
       start_time: Utility.datetime_iso8601(),
       rate_limit: String.to_integer(config[:rate_limit] || "60")
     }}
  end

  def handle_call(:control_rate_limit, _from, state) do
    sleep_time = (@rate_limit_window / state.rate_limit) |> trunc()

    {_, count} = Cachex.get(:ping_pong, Utility.cachex_counter())
    Logger.info("Count since #{state.start_time}: #{count}")

    if count > @safe_limit do
      Logger.info(
        "Ensuring #{state.name} rate limit at #{Utility.datetime_iso8601()}, waiting for #{sleep_time}"
      )

      :timer.sleep(sleep_time)
    else
      Logger.info("Request count in safe zone")
    end

    {_, count} = Cachex.decr(:ping_pong, Utility.cachex_counter())
    Logger.info("Count since #{state.start_time}: #{count}")
    {:reply, :ok, state}
  end

  def queue(name, timeout \\ :infinity) do
    GenServer.call(name, :control_rate_limit, timeout)
  end
end
