# Changelog

All notable changes to the Exaforce OpenTelemetry Collector will be documented in this file.

## [0.1.0] - 2026-04-04

### Added
- Initial release of Exaforce OpenTelemetry Collector
- Custom `httpjson` exporter for sending logs to Exaforce HTTP endpoints
  - NDJSON format output
  - Bearer token authentication
  - GZIP compression support
  - Automatic JSON flattening with dot notation
  - Built-in retry mechanism
- Windows Event Log receiver (`windowseventlog`)
- Syslog receiver for UDP/TCP
- File log receiver (`filelog`)
- Batch processor for efficient log batching
- Memory limiter processor to prevent OOM
- Resource detection processor for host metadata
- Transform processor for log manipulation (OTTL)
- Filter processor for log filtering
- AWS S3 exporter
- Debug exporter for testing
- Linux AMD64 binary
- Windows AMD64 binary
- Comprehensive documentation and examples
- GitHub Actions CI/CD pipeline

### Technical Details
- Built with OpenTelemetry Collector Builder v0.95.0
- Uses OpenTelemetry Contrib components v0.94.0
- Go 1.22 compatibility
- Cross-platform support (Linux and Windows)

### Configuration Examples
- Windows Event Logs to Exaforce
- Syslog to S3 with filtering
- File logs with transformation
- Systemd service configuration
- Windows service (NSSM) configuration

## [Unreleased]

### Planned
- Additional receiver support based on customer needs
- Enhanced httpjson exporter features
- Performance optimizations
