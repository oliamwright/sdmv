Rails.application.routes.draw do

	post '/contact', :to => "contact#submit"
	post '/contact_cms', :to => "contact#submit_cms"

  root :to => "home#index"
  get'talent/index', :to => "talent#index"
  get'search', :to => "home#search"
  get'talent-profile', :to => "home#talent-profile"
  get'book', :to => "home#book"
  get'pay', :to => "home#pay"
  get'pricing', :to => "home#pricing"
  get'community', :to => "home#community"
  get'talent', :to => "home#talent"
  get'project', :to => "home#project"
  get'projects', :to => "home#projects"
  get'profile', :to => "home#profile"

  post '/news', :to => 'data#news', :as => 'news'
  post '/social', :to => 'data#social', :as => 'social'

  resources :venues, only: [:create, :update, :destroy]
  resources :person_values, only: [:create, :update, :destroy]
end
