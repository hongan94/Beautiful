# Elasticsearch configuration using only ENV variables
enabled = ENV['USE_ELASTICSEARCH'] == 'true'

if enabled
  begin
    client = Elasticsearch::Client.new(
      url: ENV.fetch("ELASTICSEARCH_URL", "http://localhost:9200"),
      log: true
    )
    
    # Try a quick ping to see if ES is actually up
    # timeout avoids hanging during boot if ES is totally unresponsive
    client.ping
    
    Searchkick.client = client
    puts "Elasticsearch connected successfully at #{ENV.fetch('ELASTICSEARCH_URL', 'http://localhost:9200')}"
  rescue => e
    puts "Elasticsearch connection failed: #{e.message}. Disabling Searchkick callbacks."
    Searchkick.disable_callbacks
    # We can also set a global flag if needed for models to know
    ENV['USE_ELASTICSEARCH'] = 'false'
  end
else
  # Disable Searchkick if not enabled via ENV
  Searchkick.disable_callbacks
end