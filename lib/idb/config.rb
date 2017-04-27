require 'virtus'

module IDB
  class Config
    class MessageBrokerAttribute < Virtus::Attribute
      def coerce(value)
        MessageBroker.new(value)
      end
    end

    class LDAPAttribute < Virtus::Attribute
      def coerce(value)
        LDAP.new(value)
      end
    end

    class HTTPAttribute < Virtus::Attribute
      def coerce(value)
        HTTP.new(value)
      end
    end

    class SCRIPTAttribute < Virtus::Attribute
      def coerce(value)
        SCRIPT.new(value)
      end
    end

    class MessageBroker
      include Virtus.model

      attribute :host, String
      attribute :port, Integer
      attribute :user, String
      attribute :password, String
      attribute :vhost, String
      attribute :queue_maintenance, String
      attribute :ssl_cert, String
      attribute :ssl_key, String
      attribute :ssl_ca, String
    end

    class LDAP
      include Virtus.model

      attribute :host, String
      attribute :port, Integer
      attribute :base, String
      attribute :uid, String
      attribute :auth_dn, String
      attribute :auth_password, String
    end

    class HTTP
      include Virtus.model

      attribute :host, String
      attribute :port, Integer
      attribute :threads, String
    end

    class SCRIPT
      include Virtus.model

      attribute :url, String
      attribute :curl_options, String
    end

    include Virtus.model

    attribute :http, HTTPAttribute
    attribute :script, SCRIPTAttribute
    attribute :message_broker, MessageBrokerAttribute
    attribute :ldap, LDAPAttribute
  end
end
