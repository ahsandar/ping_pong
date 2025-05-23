# PingPong

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

https://dev.to/darnahsan/leveraging-genserver-and-queueing-techniques-handling-api-rate-limits-to-ai-inference-services-3i68

This is a service to use FireworksAI API. FireworksAI gives 2 set of API keys that can be used to increase your rate limit. 
You can extend the sesrvice to use anyother service as well as it only acts as a reverse request forwarding proxy. There is a rate lmiter 
in place with queue mechanism to ensusre best effort to serve all request within the rate limit.

Its build using plug cowboy and alternates between two endpoiints hence cowboys playing ping Pong

![Image](cowboy_ping_pong.jpeg)

### ENV
````
export FIREWORKS_PING_EMBEDDING_API="https://api.fireworks.ai/inference/v1/embeddings"
export FIREWORKS_PING_CHAT_API="https://api.fireworks.ai/inference/v1/chat/completions"
export FIREWORKS_PING_API_KEY="123456"
export FIREWORKS_PONG_EMBEDDING_API="https://api.fireworks.ai/inference/v1/embeddings"
export FIREWORKS_PONG_CHAT_API="https://api.fireworks.ai/inference/v1/chat/completions"
export FIREWORKS_PONG_API_KEY="654321"
export FIREWORKS_RATE_LIMIT_CHAT="60"
export FIREWORKS_RATE_LIMIT_EMBEDDING="60"
````

### Build

> nerdctl compose -f docker-compose-ci-local.yml build


### Run

> nerdctl compose -f docker-compose-local.yml up

## Sample
```

  curl --request POST \                                                                                             ─╯
  --url http://localhost:4001/fireworks/inference/v1/embeddings \
  --header 'Authorization: Bearer <token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "input": "The quick brown fox jumped over the lazy dog",
  "model": "nomic-ai/nomic-embed-text-v1.5",
  "dimensions": 2
}'
```

```

  curl --request POST \
  --url https://localhost:4001/fireworks/inference/v1/chat/completions \
  --header 'Authorization: Bearer <token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "accounts/fireworks/models/llama-v3p1-8b-instruct",
  "messages": [
    {
      "role": "system",
      "content": "<string>",
      "name": "<string>"
    }
  ],
  "tools": [
    {
      "type": "function",
      "function": {
        "description": "<string>",
        "name": "<string>",
        "parameters": {
          "type": "object",
          "required": [
            "<string>"
          ],
          "properties": {}
        }
      }
    }
  ],
  "max_tokens": 123,
  "prompt_truncate_len": 123,
  "temperature": 1,
  "top_p": 1,
  "top_k": 50,
  "frequency_penalty": 0,
  "presence_penalty": 0,
  "n": 1,
  "stop": "<string>",
  "response_format": {
    "type": "json_object",
    "schema": {}
  },
  "stream": false,
  "context_length_exceeded_behavior": "truncate",
  "user": "<string>"
}'
```
> Load test rate limiter

```
  seq 1 50 | xargs -n1 -P50 curl --request POST \                                                                         ─╯
  --url http://localhost:4001/fireworks/inference/v1/embeddings \
  --header 'content-type: application/json' \
  --data '{
  "input": "The quick brown fox jumped over the lazy dog",
  "model": "nomic-ai/nomic-embed-text-v1.5",
  "dimensions": 2
}'

```

### Tests

To run the test suite:

```bash
mix test
```

To run tests with coverage report:

```bash
mix test --cover
```
