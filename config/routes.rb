ActionController::Routing::Routes.draw do |map|
  map.logout    '/logout',   :controller => 'sessions', :action => 'destroy'
  map.login     '/login',    :controller => 'sessions', :action => 'new'
  
  map.register  '/register', :controller => 'peoples',  :action => 'create'
  map.signup    '/signup',   :controller => 'peoples',  :action => 'new'
  
  map.resources :people
  map.resource  :session
end
