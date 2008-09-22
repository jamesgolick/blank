ActionController::Routing::Routes.draw do |map|
  map.root                   :controller => 'application', :action => 'home'
  
  map.login     '/login',    :controller => 'sessions',    :action => 'new'
  map.logout    '/logout',   :controller => 'sessions',    :action => 'destroy'
  
  map.register  '/register', :controller => 'peoples',     :action => 'create'
  map.signup    '/signup',   :controller => 'peoples',     :action => 'new'
  
  map.reset_password '/reset_password', :controller => 'password_resets', :action => 'new',    :conditions => {:method => :get}
  map.reset_password '/reset_password', :controller => 'password_resets', :action => 'create', :conditions => {:method => :post}
  
  map.resources :people
  map.resource  :session
end
