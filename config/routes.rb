Rails.application.routes.draw do

  # Simple OKR routes
  #
  # get         /                 home page
  # get         /public_url       show OKR
  # get         /admin_url        show OKR with admin links
  # get         /new              new OKR (steps 1 and 2)
  # get         /share/admin_url  new OKR (step 3)
  # get         /edit/admin_url   edit OKR (steps 1 and 2)
  # get         /review/admin_url review OKR (steps 1 and 2)
  #
  # post        /okrs/id          create OKR (and associated objectives and kr)
  # patch/put   /okrs/id          update OKR (and associated objectives and kr)
  # delete      /okrs/id          destroy OKR
  # delete      /objectives/id    destroy objective (asynchronous)
  # delete      /key_results/id   destroy kr (asynchronous)  #
  #
  root 'pages#home'

  # get '/new', to: 'okrs#new', as: 'new_okr'
  get '/:url', to: 'okrs#show', as: 'show_okr'
  get '/share/:url', to: 'okrs#share', as: 'share_okr'
  get '/edit/:url', to: 'okrs#edit', as: 'edit_okr'
  get '/review/:url', to: 'okrs#review', as: 'review_okr'

  resources :okrs, only: [:new, :create, :update, :destroy]
  post '/define', to: 'okrs#define', as: 'define_okr'
  resources :objectives, only: [:new, :destroy]
  resources :key_results, only: [:new, :destroy]


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
