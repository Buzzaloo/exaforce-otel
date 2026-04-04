# Exaforce OpenTelemetry Collector

Custom OpenTelemetry Collector with components for Exaforce deployments.

## Download

**[Latest Release](https://github.com/Buzzaloo/exaforce-otel/releases/latest)**

- **Windows:** `exaforce-otel-windows-amd64.exe`
- **Linux:** `exaforce-otel-linux-amd64`

## Components

**Receivers:**
- `syslog` - Receive syslog over UDP/TCP
- `windowseventlog` - Collect Windows Event Logs
- `filelog` - Read log files

**Processors:**
- `memory_limiter` - Prevent memory overload
- `batch` - Batch logs for efficiency
- `resourcedetection` - Detect host information
- `transform` - Manipulate log data (OTTL)
- `filter` - Filter logs

**Exporters:**
- `httpjson` - **Custom exporter** for Exaforce HTTP endpoints
- `awss3` - Export to Amazon S3
- `debug` - Console output for testing

## Quick Start

### 1. Download the Collector

Download the appropriate binary for your platform from [Releases](https://github.com/Buzzaloo/exaforce-otel/releases).

**Linux:**
```bash
wget https://github.com/Buzzaloo/exaforce-otel/releases/latest/download/exaforce-otel-linux-amd64
chmod +x exaforce-otel-linux-amd64
```

**Windows:**
Download `exaforce-otel-windows-amd64.exe` from the releases page.

### 2. Create Configuration

Create `config.yaml`:

```yaml
receivers:
  windowseventlog:
    channel: Security

processors:
  batch:
    send_batch_size: 100
    timeout: 10s

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

### 3. Run the Collector

**Linux:**
```bash
./exaforce-otel-linux-amd64 --config config.yaml
```

**Windows:**
```powershell
.\exaforce-otel-windows-amd64.exe --config config.yaml
```

## httpjson Exporter

The `httpjson` exporter sends logs to HTTP endpoints in NDJSON format.

### Configuration

```yaml
exporters:
  httpjson:
    # Required
    endpoint: "https://hooks.exaforce.com/ingest/YOUR_ID"
    bearer_token: "YOUR_TOKEN"
    
    # Optional
    compression: gzip          # none or gzip (default: none)
    timeout: 30s               # HTTP timeout (default: 30s)
    
    # Retry settings
    retry_on_failure:
      enabled: true
      initial_interval: 5s
      max_interval: 30s
      max_elapsed_time: 300s
```

### Features

- **NDJSON format** - One JSON object per line
- **Automatic JSON flattening** - Nested objects flattened with dot notation
- **Bearer token auth** - Standard Authorization header
- **GZIP compression** - Reduce bandwidth
- **Built-in retry** - Automatic retry on failures

## Example Configurations

### Windows Event Logs to Exaforce

```yaml
receivers:
  windowseventlog/system:
    channel: System
  windowseventlog/application:
    channel: Application
  windowseventlog/security:
    channel: Security

processors:
  memory_limiter:
    check_interval: 2s
    limit_mib: 500
  batch:
    send_batch_size: 100
    timeout: 10s

exporters:
  httpjson:
    endpoint: "https://hooks.exaforce.com/ingest/${EXAFORCE_CONNECTOR_ID}"
    bearer_token: "${EXAFORCE_TOKEN}"
    compression: gzip

service:
  pipelines:
    logs:
      receivers: [windowseventlog/system, windowseventlog/application, windowseventlog/security]
      processors: [memory_limiter, batch]
      exporters: [httpjson]
```

### Syslog to S3 with Filtering

```yaml
receivers:
  syslog:
    udp:
      listen_address: "0.0.0.0:514"
    protocol: rfc3164

processors:
  filter:
    logs:
      log_record:
        # Drop debug logs
        - 'severity_text == "DEBUG"'
  batch: {}

exporters:
  awss3:
    s3uploader:
      region: us-east-1
      s3_bucket: my-logs
      s3_prefix: syslog/
      s3_partition_format: "year=%Y/month=%m/day=%d"

service:
  pipelines:
    logs:
      receivers: [syslog]
      processors: [filter, batch]
      exporters: [awss3]
```

### File Logs with Transformation

```yaml
receivers:
  filelog:
    include:
      - /var/log/app/*.log
    start_at: beginning

processors:
  transform:
    log_statements:
      - context: log
        statements:
          # Add custom attribute
          - set(attributes["environment"], "production")
          # Parse JSON body if present
          - merge_maps(cache, ParseJSON(body), "upsert") where IsString(body)
          - merge_maps(attributes, cache, "upsert")
  batch: {}

exporters:
  httpjson:
    endpoint: "https://hooks.exaforce.com/ingest/${EXAFORCE_CONNECTOR_ID}"
    bearer_token: "${EXAFORCE_TOKEN}"

service:
  pipelines:
    logs:
      receivers: [filelog]
      processors: [transform, batch]
      exporters: [httpjson]
```

## Running as a Service

### Windows Service (using NSSM)

1. Download NSSM: https://nssm.cc/download
2. Install as service:

```powershell
nssm install ExaforceOTEL "C:\otel\exaforce-otel-windows-amd64.exe" "--config C:\otel\config.yaml"
nssm start ExaforceOTEL
```

### Linux Systemd Service

Create `/etc/systemd/system/exaforce-otel.service`:

```ini
[Unit]
Description=Exaforce OpenTelemetry Collector
After=network.target

[Service]
Type=simple
User=otel
ExecStart=/usr/local/bin/exaforce-otel-linux-amd64 --config /etc/otel/config.yaml
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable exaforce-otel
sudo systemctl start exaforce-otel
sudo systemctl status exaforce-otel
```

## Troubleshooting

### Logs Not Appearing

1. Check collector is running with `--config` flag
2. Verify endpoint URL and bearer token
3. Test network connectivity to endpoint
4. Enable debug logging:

```yaml
service:
  telemetry:
    logs:
      level: debug
```

### High Memory Usage

Reduce batch size and queue settings:

```yaml
processors:
  batch:
    send_batch_size: 50
    timeout: 5s
  memory_limiter:
    limit_mib: 256
```

## Building from Source

```bash
# Clone the repo
git clone https://github.com/Buzzaloo/exaforce-otel.git
cd exaforce-otel

# Install OpenTelemetry Collector Builder
go install go.opentelemetry.io/collector/cmd/builder@v0.95.0

# Build
builder --config builder-config.yaml

# Binary will be in: ./dist/exaforce-otel
```

## Version Information

- **Builder:** v0.95.0
- **Components:** v0.94.0
- **Go:** 1.21+

## License

Apache License 2.0

## Support

- Issues: https://github.com/Buzzaloo/exaforce-otel/issues
- Exaforce Support: support@exaforce.com
