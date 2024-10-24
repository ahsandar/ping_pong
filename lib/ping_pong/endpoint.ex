defmodule PingPong.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  use Plug.Router
  alias PingPong.Chat, as: Chat
  alias PingPong.Embedding, as: Embedding
  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)
  # responsible for matching routes
  plug(:match)
  # Using Jason for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  # responsible for dispatching responses
  plug(:dispatch)

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  get "/heartbeatz" do
    send_resp(conn, 200, "I am  alive!")
  end

  # Handle incoming events, if the payload is the right shape, process the
  # events, otherwise return an error.
  post "/fireworks/inference/v1/chat/completions" do
    {status, body} =
      case conn.body_params do
        %{"model" => _model, "messages" => _messages} = body -> Chat.fireworks(body)
        _ -> {422, missing_events()}
      end

    send_resp(conn, status, body |> Jason.encode!())
  end

  post "/fireworks/inference/v1/embeddings" do
    {status, body} =
      case conn.body_params do
        %{"model" => _model, "input" => _input} = body -> Embedding.fireworks(body)
        _ -> {422, missing_events()}
      end

    send_resp(conn, status, body |> Jason.encode!())
  end

  defp missing_events do
    Jason.encode!(%{error: "Expected Payload: { 'events': [...] }"})
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing here :)")
  end
end
