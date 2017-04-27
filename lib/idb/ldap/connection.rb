require 'net/ldap'
require 'idb/ldap/user'

module IDB
  module LDAP
    class Connection
      def initialize(config)
        options = {
          base: config.base,
          host: config.host,
          port: config.port || 389 # SSL port: 636
        }

        if config.auth_dn && !config.auth_dn.empty?
          options[:encryption] = :simple_tls
          options[:auth] = {
            method: :simple,
            username: config.auth_dn,
            password: config.auth_password
          }
        end

        @uid = config.uid
        @ldap = Net::LDAP.new(options)
      end

      def find_user(login, password)
        filter = Net::LDAP::Filter.eq(@uid, login)
        response = @ldap.bind_as(filter: filter, password: password)

        response ? LDAP::User.new(response.first) : false
      end
    end
  end
end
