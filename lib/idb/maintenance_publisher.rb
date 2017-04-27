require 'stomp'
require 'multi_json'

module IDB
  class MaintenancePublisher
    def initialize(config)
      @config = config
      @connection = Stomp::Client.new(params)
      @queue = "/queue/#{@config.queue_maintenance}"
    end

    def publish(payload)
      @connection.publish(@queue, encode(payload), persistent: true)
    end

    private

    def host_params
      {
        :host => @config.host,
        :port => @config.port,
        :login => @config.user,
        :passcode => @config.password,
        :ssl => Stomp::SSLParams.new({
          :cert_file => @config.ssl_cert,
          :key_file => @config.ssl_key,
          :ts_files => @config.ssl_ca,
          :use_ruby_ciphers => true # Unbreaks JRuby
        })
      }
    end

    def params
      {
        :hosts => [host_params],
        :connect_headers => {
          :host => @config.vhost,
          :'accept-version' => '1.1',
          :'heart-beat' => '500,500',
        }
      }
    end

    def encode(data)
      data.respond_to?(:to_hash) ? MultiJson.dump(data.to_hash) : data.to_s
    end
  end
end
