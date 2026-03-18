FROM ghcr.io/sparfenyuk/mcp-proxy:latest

# Install uv so we can run uvx mcp-server-fetch
RUN python3 -m ensurepip && \
    pip install --no-cache-dir uv

ENV PATH="/usr/local/bin:$PATH" \
    UV_PYTHON_PREFERENCE=only-system

EXPOSE 8001

ENTRYPOINT ["catatonit", "--", "mcp-proxy"]
CMD ["--pass-environment", "--host", "0.0.0.0", "--port", "8001", "uvx", "mcp-server-fetch"]
