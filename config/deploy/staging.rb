set :rails_env, 'staging'

set :branch, 'develop'

role :app, %w{deploy@staging.venue.eventhub.com.au}
role :web, %w{deploy@staging.venue.eventhub.com.au}
role :db,  %w{deploy@staging.venue.eventhub.com.au}

server 'staging.venue.eventhub.com.au', user: 'deploy', roles: %w{web app}

set :deploy_to, '/srv/www/staging.venue.eventhub.com.au'