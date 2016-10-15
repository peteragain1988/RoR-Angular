Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == 'aloevera' && user == 'tangerine'
end