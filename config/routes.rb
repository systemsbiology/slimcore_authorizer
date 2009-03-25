ActionController::Routing::Routes.draw do |map|
  map.resources :users do |users|
    users.resources :lab_memberships, :name_prefix => "user_"
  end
  map.resources :lab_memberships
  map.resources :lab_groups
  map.resources :registrations
end
