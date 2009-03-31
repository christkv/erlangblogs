ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :password_resets
  map.resources :users
  map.resource :user_session
  map.resource :search

  map.avatar   '/avatar', :controller => 'users', :action => 'avatar'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'  
  
  map.root :controller => "user_sessions", :action => "new"
end
