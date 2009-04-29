ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :password_resets
  map.resources :users
  map.resource :user_session
  map.resource :search

  map.avatar   '/avatar', :controller => 'users', :action => 'avatar'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  map.project '/project', :controller => 'project', :action => 'index'
  map.project_show '/project/:id', :controller => 'project', :action => 'show'
  map.project_follow '/project/follow/:id', :controller => 'project', :action => 'follow'
  map.project_remove_follow '/project/remove_follow/:id', :controller => 'project', :action => 'remove_follow' 

  map.resources :facebook, :collection => {:link_user_accounts => :get}
  
  map.root :controller => "home"
end
