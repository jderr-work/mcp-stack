# MCP Server Stack

A self-hosted [Model Context Protocol (MCP)](https://modelcontextprotocol.io) server stack running via Docker Compose. All servers are exposed through a single Nginx reverse proxy at `http://localhost:9000`.

## Services

| Service | Route prefix | Description |
|---|---|---|
| GitHub | `/github-official/` | [github-mcp-server](https://github.com/github/github-mcp-server) — GitHub API tools |
| Atlassian | `/atlassian/` | [mcp-atlassian](https://github.com/sooperset/mcp-atlassian) — Jira tools |
| Fetch | `/fetch/` | [mcp-server-fetch](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch) — HTTP fetch tool |
| DuckDuckGo | `/duckduckgo/` | [duckduckgo-mcp-server](https://github.com/nickclyde/duckduckgo-mcp-server) — Web search |
| Playwright | `/playwright/` | [@playwright/mcp](https://github.com/microsoft/playwright-mcp) — Headless Chromium browser automation |

Each service supports both **streamable HTTP** (`/mcp`) and **SSE** (`/sse`) transports, except GitHub which uses streamable HTTP only.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) with the Compose plugin

## Environment Variables

The following variables must be present in your shell environment before running the stack. Docker Compose reads them directly from the environment, so exporting them in your shell profile (e.g., `~/.zshrc`) is sufficient — no `.env` file required.

| Variable | Description |
|---|---|
| `GITHUB_MCP_TOKEN` | GitHub Personal Access Token |
| `JIRA_URL` | Your Atlassian instance URL (e.g., `https://yourorg.atlassian.net`) |
| `JIRA_USERNAME` | Your Atlassian account email |
| `JIRA_TOKEN` | Jira API token |

Example `~/.zshrc` additions:

```sh
export GITHUB_MCP_TOKEN=ghp_...
export JIRA_URL=https://yourorg.atlassian.net
export JIRA_USERNAME=you@example.com
export JIRA_TOKEN=...
```

## Usage

Use the `mcp.sh` helper script. It resolves its own path, so it works from any directory.

```sh
# Build custom images and start all services in the background
./mcp.sh build

# Start all services (using existing images)
./mcp.sh up

# Stop all services
./mcp.sh down
```

## Endpoints

Once the stack is running, each server is reachable at:

```
http://localhost:9000/<service>/mcp   # streamable HTTP transport
http://localhost:9000/<service>/sse   # SSE transport
```

For example:

```
http://localhost:9000/github-official/mcp
http://localhost:9000/atlassian/mcp
http://localhost:9000/fetch/mcp
http://localhost:9000/duckduckgo/mcp
http://localhost:9000/playwright/mcp
```

A health check endpoint is also available:

```
http://localhost:9000/health
```

## Wiring into an MCP Client

Configure your MCP client (e.g., [opencode](https://opencode.ai), Claude Desktop) to point at the relevant endpoint. Example for a streamable HTTP client:

```json
{
  "url": "http://localhost:9000/github-official/mcp"
}
```

## Architecture

```
localhost:9000
      │
   Nginx (nginx.conf)
      │
      ├── /github-official/ → github-official:8082
      ├── /atlassian/       → atlassian:8000
      ├── /fetch/           → mcp-fetch:8001
      ├── /duckduckgo/      → mcp-duckduckgo:8002
      └── /playwright/      → mcp-playwright:8003
```

Nginx is configured for SSE compatibility: buffering and caching are disabled, and timeouts are set to 24 hours to support long-lived connections.
