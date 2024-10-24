# PingPong

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


![Image](cowboy_ping_pong.jpeg)

### ENV
````
export FIREWORKS_PING_EMBEDDING_API="https://api.fireworks.ai/inference/v1/embeddings"
export FIREWORKS_PING_CHAT_API="https://api.fireworks.ai/inference/v1/chat/completions"
export FIREWORKS_PING_API_KEY="123456"
export FIREWORKS_PONG_EMBEDDING_API="https://api.fireworks.ai/inference/v1/embeddings"
export FIREWORKS_PONG_CHAT_API="https://api.fireworks.ai/inference/v1/chat/completions"
export FIREWORKS_PONG_API_KEY="654321"
````

### Build

> nerdctl compose -f docker-compose-ci-local.yml build


### Run

> nerdctl compose -f docker-compose-local.yml up
