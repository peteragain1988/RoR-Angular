module TicketProviders
  module Ticketek
    class AuthenticationToken
      require 'signet/oauth_2/client'
      include Singleton

      @@semaphore ||= Mutex.new


      def self.set(token,expiry)
        @@semaphore.synchronize do
          Sidekiq.redis do |conn|
            conn.set :ticketek_auth_token, token
            conn.expire :ticketek_auth_token, expiry - 20
          end
        end
      end

      def self.get
        @@semaphore.synchronize do
          Sidekiq.redis do |conn|
            conn.get :ticketek_auth_token
          end
        end
      end

      def self.authenticate
        @@semaphore.synchronize do
          api_options = TicketProviders::Ticketek::Configuration.get
          puts "apioption #{api_options}"
          @client = Signet::OAuth2::Client.new(
            token_credential_uri: api_options[:token_url],
            client_id: api_options[:client_id],
            client_secret: api_options[:client_secret]
          )
          puts "ClientAUTH #{@client}"
          
          @client.grant_type = 'client_credentials'

          begin
            @client.fetch_access_token!
            puts "Authentication OK"
          rescue Signet::AuthorizationError => error
            puts "Authentication Failed"
            throw error
          end
        end

        self.set @client.access_token, @client.expires_in
      end


    end
  end
end