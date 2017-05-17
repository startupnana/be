Rails.application.routes.draw do
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
  get '/synthesizer/ping' => 'mpsynthesizer#ping'
  post '/synthesizer/synthesize' => 'mpsynthesizer#synthesize'
  post '/synthesizer/makeover' => 'mpsynthesizer#makeover'
  post '/synthesizer/makeover_synthesize' => 'mpsynthesizer#makeover_synthesize'
  post '/synthesizer/feature_points' => 'mpsynthesizer#feature_points'

  post '/synthesizer/aging/:mode' => 'mpsynthesizer_aging#aging', constraints: {mode: /(2|3)d/}

  post '/synthesizer/moviemaker/shoot' => 'mpsynthesizer_moviemaker#shoot'
  get '/synthesizer/moviemaker/:uid' => 'mpsynthesizer_moviemaker#job_result'

  get '/analyzer/ping' => 'mpanalyzer#ping'
  post '/analyzer/analyze' => 'mpanalyzer#analyze'

  post '/card_detection/detect' => 'card_detection#detect'

  post '/create' => 'users#create' # Legacy. Remove once the PHP server is updated.
  post '/users/create' => 'users#create'

  post '/mpitemedit/glasses/background' => 'mpitemedit#getglassesbg'
  post '/mpitemedit/glasses/feature_points' => 'mpitemedit#genglassesfp'
end