module github.com/Buzzaloo/exaforce-otel/exporter/httpjsonexporter

go 1.22

require (
	go.opentelemetry.io/collector/component v0.114.0
	go.opentelemetry.io/collector/config/confighttp v0.114.0
	go.opentelemetry.io/collector/config/configopaque v1.20.0
	go.opentelemetry.io/collector/config/configretry v1.20.0
	go.opentelemetry.io/collector/exporter v0.114.0
	go.opentelemetry.io/collector/exporter/exporterhelper v0.114.0
	go.opentelemetry.io/collector/pdata v1.20.0
	go.uber.org/zap v1.27.0
)
