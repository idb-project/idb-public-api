require 'grape'
require 'idb'
require 'idb/maintenance_record'
require 'idb/maintenance_publisher'
require 'idb/user_auth'

module IDB
  class API < Grape::API
    use Rack::Runtime
    use Rack::CommonLogger

    format :json

    helpers do
      def current_user
        @current_user
      end

      def config
        IDB.config
      end

      def publisher
        # Stores the publisher instance in a thread-local to avoid thread
        # safety issues with the stomp gem.
        Thread.current[:mpub] ||= IDB::MaintenancePublisher.new(config.message_broker)
      end

      def script_content(name)
        File.read(File.expand_path("../../../scripts/#{name}", __FILE__))
      end

      def authorize!
        @current_user = IDB::UserAuth.new(IDB.config).valid_login?(env)

        error!('401 Unauthorized', 401) unless @current_user
      end
    end

    before do
      authorize! unless route.route_namespace == '/health'
    end

    resource :machines do
      desc 'Creates a new maintenance entry for a machine'
      params do
        requires :screenlog, desc: 'The maintenance screen log'
        optional :timestamp, type: Time, desc: 'The maintenance date'
        optional :noservice, type: String, desc: 'A no-service flag'
      end
      post ':fqdn/maintenance', requirements: {fqdn: /.+/} do
        record = IDB::MaintenanceRecord.new(params, current_user)

        # Publish the maintenance record to the message bus.
        publisher.publish(record)

        {success: true}
      end
    end

    resource :health do
      desc 'Returns the app health. Useful for monitoring.'
      get do
        {status: 'OK'}
      end
    end

    resource :scripts do
      desc 'Returns the maintenance shell script.'
      get 'idb-service' do
        content_type 'text/plain'
        header 'Content-Disposition', 'attachment; filename="idb-service"'

        # Workaround to fix formatting.
        env['api.format'] = :binary

        content = script_content('idb-service')
        content.gsub!("%curl_options%", config.script.curl_options)
        content.gsub!("%url%", config.script.url)
        body content
      end
    end
  end
end
