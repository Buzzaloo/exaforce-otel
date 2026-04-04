module github.com/Buzzaloo/exaforce-otel/exporter/httpjsonexporter

go 1.21

require (
	go.opentelemetry.io/collector/component v0.94.0
	go.opentelemetry.io/collector/config/confighttp v0.94.0
	go.opentelemetry.io/collector/config/configopaque v0.94.0
	go.opentelemetry.io/collector/config/configretry v0.94.0
	go.opentelemetry.io/collector/exporter v0.94.0
	go.opentelemetry.io/collector/exporter/exporterhelper v0.94.0
	go.opentelemetry.io/collector/pdata v1.2.0
	go.uber.org/zap v1.26.0
)
