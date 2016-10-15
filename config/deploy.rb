# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'eventhub'
set :repo_url, 'git@bitbucket.org:kernel/thms-rails.git'
set :tmp_dir, '/home/deploy/tmp'


set :scm, :git
set :chruby_ruby, 'ruby-2.1.2'

set :format, :pretty

set :pty, false

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/tickets config/keys}
set :keep_releases, 5

# Start a sidekiq process on these queues
set :sidekiq_queue, ['default','tickets','mailer']

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
