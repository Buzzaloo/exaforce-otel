# Exaforce OpenTelemetry Collector

Custom OpenTelemetry Collector with components for Exaforce deployments.

## Components

**Receivers:**
- syslog - Receive syslog over UDP/TCP
- windowseventlog - Collect Windows Event Logs
- filelog - Read log files

**Processors:**
- memory_limiter - Prevent memory overload
- batch - Batch logs for efficiency
- resourcedetection - Detect host information
- transform - Manipulate log data
- filter - Filter logs

**Exporters:**
- awss3 - Export to Amazon S3
- httpjson - Export to HTTP endpoints (Exaforce)
- debug - Console output for testing

## Download

[Latest Release](https://github.com/Buzzaloo/exaforce-otel/releases)

## Quick Start

```yaml
receivers:
  windowseventlog:
    channel: Security

processors:
  batch: {}

exporters:
  httpjson:
    endpoint: "https://hooks.exaforce.com/ingest/YOUR_CONNECTOR_ID"
    bearer_token: "YOUR_TOKEN"
    compression: gzip

service:
  pipelines:
    logs:
      receivers: [windowseventlog]
      processors: [batch]
      exporters: [httpjson]
```

Run: `./exaforce-otel-linux-amd64 --config config.yaml`

## httpjsonexporter

The httpjsonexporter sends logs to HTTP endpoints in NDJSON format with:
- Bearer token authentication
- Automatic JSON body flattening
- GZIP compression support
- Standard OTEL retry/queue mechanisms

See [httpjson-exporter](https://github.com/Buzzaloo/httpjson-exporter) for details.

## Building from Source

```bash
# Install OpenTelemetry Collector Builder
go install go.opentelemetry.io/collector/cmd/builder@v0.114.0

# Build
builder --config builder-config.yaml

# Binary will be in: ./dist/exaforce-otel
```

