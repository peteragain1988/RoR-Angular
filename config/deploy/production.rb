set :rails_env, 'production'

set :branch, 'master'

role :app, %w{deploy@venue.eventhub.com.au}
role :web, %w{deploy@venue.eventhub.com.au}
role :db,  %w{deploy@venue.eventhub.com.au}

server 'venue.eventhub.com.au', user: 'deploy', roles: %w{web app}

set :deploy_to, '/srv/www/venue.eventhub.com.au'