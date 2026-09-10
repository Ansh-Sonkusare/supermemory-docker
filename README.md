# supermemory-docker

Dockerized [supermemory](https://github.com/supermemoryai/supermemory) server — a local AI memory layer — plus the [supermemory-dashboard](https://github.com/Ansh-Sonkusare/supermemory-dashboard) web UI. One `docker compose up` gives you a full local memory stack.

## What you get

| Service | Port | URL | Purpose |
|---|---|---|---|
| `supermemory` | 6767 | http://localhost:6767 | The memory API server (supermemory-server `v0.0.8`) |
| `dashboard` | 5173 | http://localhost:5173 | Web UI: memories, search, memory graph, add, settings |

The dashboard is served behind nginx, which proxies `/api/*` to the server, so everything is same-origin and the self-hosted binary's missing CORS headers are never an issue.

## Usage

### With a hosted LLM key

```
# Set your Gemini API key
export GEMINI_API_KEY="your-key"

# Build and start the stack
docker compose up -d --build

# Dashboard: http://localhost:5173
# Server:   http://localhost:6767
```

### Fully offline (Ollama)

Set `GEMINI_API_KEY` to an empty string and point the server at Ollama during its first-boot setup wizard (`gpt-oss:20b` works well). Nothing leaves your machine.

## First boot

On first boot, the server runs a one-time setup wizard. It prints the API key to the server logs:

```
docker compose logs supermemory
```

The key is also persisted in the container at `/data/api-key`:

```
docker compose exec supermemory cat /data/api-key
```

Open http://localhost:5173 → **Settings**, enter the API key (backend URL already defaults to `/api`), save, and you're in.

## Data

Persisted in a named Docker volume (`supermemory-data`). Delete it to factory reset:

```
docker compose down -v
```

## Updating

```
git pull
docker compose up -d --build
```

The dashboard is built from the latest `main` of [supermemory-dashboard](https://github.com/Ansh-Sonkusare/supermemory-dashboard) at image build time, so `--build` picks up both the newest server release and the newest UI.

## Running just the server

Want the bare API without the dashboard? Make it a one-off:

```
docker compose up -d --no-deps supermemory
```

Or pin only that service in your compose file by removing the `dashboard` block above.