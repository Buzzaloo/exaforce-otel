module github.com/Buzzaloo/exaforce-otel

go 1.22

require github.com/Buzzaloo/exaforce-otel/exporter/httpjsonexporter v0.0.0

replace github.com/Buzzaloo/exaforce-otel/exporter/httpjsonexporter => ./exporter/httpjsonexporter
