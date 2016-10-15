# ThmsRails::Application.configure do
#
#   config.x.ticketek_provider.send_tickets_user = 'dev' if Rails.env.development?
#   config.x.ticketek_provider.send_tickets_user = 'prod' if Rails.env.production?
#
#   # OAuth is actually disabled at the moment
#   config.x.ticketek_provider.oauth_enabled = false
#
#   if config.x.ticketek_provider.oauth_enabled
#     # Turns out this is beta, not production
#     config.x.ticketek_provider.oauth_token_uri = 'https://uat-auth.ticketek.com.au/OAuth2/AccessToken'
#     config.x.ticketek_provider.request_uri = 'https://uat-api-cts.ticketek.com.au/Tickets/'
#
#     # TODO Store these in an environment variable for ultra-paranoid security
#     config.x.ticketek_provider.client_id = 'bb7d34c974b04253ad0535309ab9bc86'
#     config.x.ticketek_provider.client_secret = '26a3b180fc244ceb9405683ba43ba32e'
#   else
#     # this is the 'Production' API
#     config.x.ticketek_provider.request_uri = 'https://turnkeycts.ticketek.com.au/Tickets/'
#     config.x.ticketek_provider.authentication_token = '1AF8DA37-B774-48C3-B320-A8497EF4309D'
#   end
#
# end