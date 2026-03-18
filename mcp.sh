#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $(basename "$0") <up|down|build>"
  exit 1
}

[[ $# -ne 1 ]] && usage

case "$1" in
  up)
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d
    ;;
  down)
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" down
    ;;
  build)
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" build
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d
    ;;
  *)
    usage
    ;;
esac
