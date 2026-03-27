require 'prometheus_exporter/middleware'
require 'prometheus_exporter/instrumentation'

# Check if Prometheus is enabled via ENV only
def prometheus_enabled?
  ENV['USE_PROMETHEUS'] == 'true'
end

if prometheus_enabled? && (Rails.env.production? || Rails.env.development?)
  # 1. Chèn Middleware đo HTTP requests
  Rails.application.config.middleware.insert_after(
    Rack::Runtime,
    PrometheusExporter::Middleware
  )

  # 2. Khởi tạo Instrumentation và Collector client
  puts "Initializing Prometheus Exporter..."
  PrometheusExporter::Instrumentation::ActiveRecord.start
  PrometheusExporter::Instrumentation::Process.start(type: "worker")
end
