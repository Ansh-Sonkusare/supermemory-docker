# supermemory-docker

Dockerized [supermemory-server](https://github.com/supermemoryai/supermemory) — a local AI memory layer. Single container, everything persisted in a Docker volume.

## What you get

- **supermemory-server v0.0.8** — the full Memory API (documents, memories, hybrid search) on `http://localhost:6767`
- Local CPU embeddings out of the box (`Xenova/bge-base-en-v1.5`) — no embedding API key required
- Bring your own LLM: OpenAI, Anthropic, Gemini, Groq, or any OpenAI-compatible endpoint (Ollama, vLLM, LM Studio, a local proxy…)

## Quickstart

The server refuses to boot until **at least one LLM provider is configured** (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`, or `GROQ_API_KEY`). Drop your values in a `.env` file next to the compose file, then start:

```bash
# .env
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...      # or any one provider key
```

```bash
docker compose up -d --build
```

> Using Podman? The commands are the same (`podman compose up -d --build`).

First boot prints an API key to the logs. Open the settings/docs with it — it's also auto-applied for unauthenticated localhost requests:

```
docker compose logs supermemory | grep -E 'sm_|api key'
# or read it back out of the data directory
docker compose exec supermemory cat /data/api-key
```

## Point at a local LLM (Ollama / vLLM / LM Studio / proxy)

Don't want to use a hosted provider? Point the `OPENAI_*` vars at any OpenAI-compatible endpoint. Nothing leaves your machine.

```bash
# .env — Docker
OPENAI_API_KEY=dummy
OPENAI_BASE_URL=http://host.docker.internal:20128/v1
OPENAI_MODEL=free-first

# .env — Podman (the host alias differs from Docker)
OPENAI_API_KEY=dummy
OPENAI_BASE_URL=http://host.containers.internal:20128/v1
OPENAI_MODEL=free-first
```

## Configuration

Everything is tunable via environment variables in `.env`. Defaults shown below; the compose file uses `${VAR:-default}` so unset vars fall back gracefully.

| Variable | Default | Purpose |
|---|---|---|
| `OPENAI_API_KEY` | *(empty)* | OpenAI-compatible key. Set `dummy` when using a local endpoint. One of the four keys below is required. |
| `OPENAI_BASE_URL` | *(empty)* | OpenAI-compatible base URL, e.g. `http://host.docker.internal:20128/v1`. |
| `OPENAI_MODEL` | *(empty)* | Model name to use against the endpoint. |
| `GEMINI_API_KEY` | *(empty)* | Gemini key (alternative provider). |
| `ANTHROPIC_API_KEY` | *(empty)* | Anthropic key (alternative provider). |
| `GROQ_API_KEY` | *(empty)* | Groq key (alternative provider). |
| `SUPERMEMORY_PORT` | `6767` | Host port for the server, e.g. `6768` if `6767` is taken. Inside the container the server always listens on `6767` (`PORT`). |
| `SUPERMEMORY_DATA_DIR` | `/data` | Where state lives inside the container. |
| `SUPERMEMORY_EMBEDDING_PROVIDER` | `local` | Embedding backend: `local` (CPU, default), or OpenAI/Gemini/Ollama. |
| `SUPERMEMORY_EMBEDDING_MODEL` | `Xenova/bge-base-en-v1.5` | Embedding model name. |
| `SUPERMEMORY_EMBEDDING_DIMENSIONS` | `768` | Embedding vector width; must match the model. |
| `SUPERMEMORY_EMBEDDING_RAM_LIMIT` | `1gb` | Ingest memory budget; raise it (e.g. `2gb`) if ingestion is slow. |

## Data

State (documents, vectors, encrypted config) lives in the named volume `supermemory-data` at `/data`. Delete it to factory reset:

```bash
docker compose down -v
```

The server is licensed "lite" up to 10k documents.

## Updating

```bash
git pull
docker compose build --no-cache   # picks up newest server release
docker compose up -d
```

Unused old images: `docker image prune`.