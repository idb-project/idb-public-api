require 'idb/ldap/connection'

module IDB
  class UserAuth
    def initialize(config)
      @config = config
    end

    def valid_login?(env)
      basic = Rack::Auth::Basic::Request.new(env)

      if basic.provided?
        ldap = IDB::LDAP::Connection.new(@config.ldap)
        ldap.find_user(*basic.credentials)
      else
        false
      end
    end
  end
end
