# Start from the official playwright MCP image which has Node.js + Chromium
FROM mcp/playwright AS playwright-base

# Switch to root to install Python + mcp-proxy
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        catatonit \
    && rm -rf /var/lib/apt/lists/*

# Install mcp-proxy
RUN pip install --no-cache-dir --break-system-packages mcp-proxy

EXPOSE 8003

ENTRYPOINT ["catatonit", "--", "mcp-proxy"]
# Use -- to separate mcp-proxy flags from the subprocess command+args,
# so argparse doesn't try to claim --headless/--browser/--no-sandbox as its own.
CMD ["--pass-environment", "--host", "0.0.0.0", "--port", "8003", \
     "--", "node", "/app/cli.js", "--headless", "--browser", "chromium", "--no-sandbox"]
