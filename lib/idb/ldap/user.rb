module IDB
  module LDAP
    class User
      attr_reader :dn, :name, :login, :email

      def initialize(ldap_entry)
        @dn = Array(ldap_entry[:dn]).first
        @name = ldap_entry[:cn].first
        @login = ldap_entry[:uid].first
        @email = ldap_entry[:mail].first
      end

      def attributes
        {login: login, name: name, email: email}
      end
    end
  end
end
