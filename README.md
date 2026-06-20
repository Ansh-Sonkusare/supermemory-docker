# supermemory-docker

Dockerized [supermemory](https://github.com/supermemoryai/supermemory) server — a local AI memory layer.

## Usage

```
# Set your Gemini API key
export GEMINI_API_KEY="your-key"

# Build and start
docker compose up -d

# Server runs at http://localhost:6767
```

## API Key

On first boot, the server auto-generates an API key at `/data/api-key` (inside the container). View it with:

```
docker compose exec supermemory cat /data/api-key
```

Set a custom one by creating the file before starting:

```
echo "sm_your_custom_key" > .supermemory-api-key
```

Then uncomment the bind mount in `docker-compose.yml`.

## Data

Persisted in a named Docker volume (`supermemory-data`). Delete it to factory reset:

```
docker compose down -v
```
