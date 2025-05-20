defmodule PingPong.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts PingPong.Endpoint.init([])

  test "returns 200 for heartbeat check" do
    conn = conn(:get, "/heartbeatz")
    conn = PingPong.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "I am  alive!"
  end

  test "returns 404 for unknown routes" do
    conn = conn(:get, "/unknown")
    conn = PingPong.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "oops... Nothing here :)"
  end

  test "returns 422 for invalid chat completion request" do
    conn =
      conn(:post, "/fireworks/inference/v1/chat/completions", %{invalid: "payload"})
      |> put_req_header("content-type", "application/json")

    conn = PingPong.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body =~ "error"
  end

  test "returns 422 for invalid embedding request" do
    conn =
      conn(:post, "/fireworks/inference/v1/embeddings", %{invalid: "payload"})
      |> put_req_header("content-type", "application/json")

    conn = PingPong.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body =~ "error"
  end
end
