require 'time'

module IDB
  class MaintenanceRecord
    attr_reader :fqdn, :timestamp, :screenlog, :user, :noservice

    def initialize(params, user)
      @fqdn = params[:fqdn]
      @timestamp = params[:timestamp] || Time.now
      @screenlog = params[:screenlog].tempfile.read
      @noservice = params[:noservice]
      @user = user
    end

    def to_hash
      {
        fqdn: fqdn,
        timestamp: timestamp.iso8601,
        screenlog: encode(screenlog),
        noservice: noservice,
        user: user.attributes
      }
    end

    private

    def encode(data)
      # Base64 encode the passed data.
      [data.to_s].pack('m').gsub("\n", '')
    end
  end
end
