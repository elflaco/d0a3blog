D0A3::Application.routes.draw do

  resources :families do 
    resources :people#, only: [:index, :show]
    resources :addresses, only: [:new, :create, :edit, :update]
  end

  resources :groups do
    resources :lectures do
      resources :attendances
      resources :exercises
    end
    resources :calendars
    resources :spots do
      resources :payments
    end
  end

  resources :plans
  resources :users
  resources :program_relations
  resources :courses
  resources :programs do
    resources :courses
  end
  resources :lessons do
    resources :program_relations
  end

  resources :lectures
  resources :payments
  resources :exercises
  resources :calendars
  resources :password_resets
  resources :people, only: [:index, :show]
  resources :sessions, only: [:new, :create, :destroy]

  root 'sessions#new'

  get "users/index"
  get "lectures/observation"
  get "sessions/new"
  get "sessions/edit"
  get "sessions/create"
  get "sessions/destroy"
  post "payments/search"
  post "people/search"
  post "exercises/search"
  get "exercises/plan"
  post "program_relations/search"
  get "programs/reorder"
  get "programs/lecture"
  get "spots/deactivated"
  get "spots/observation"

  # resources :people do
  #   collection do
  #     get 'search'
  #   end
  # end

  match '/user',    to: 'users#show',           via: 'get'
  match '/edit',    to: 'users#edit',           via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  get ':controller(/:action(/:id))(.:format)'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
