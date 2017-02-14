Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for :users, path: ''
  resources  :projects

  resources  :users, except: [:new, :create] do
    member do
      get 'edit_password'
      put 'update_password'
    end
  end

  resources :reports, except: :destroy, shallow: true do
    member do
      get 'edit_assignee'
      put 'assign_to_me'
      put 'update_assignee'
      put 'close'
      put 'open'
      get 'edit_labels'
      put 'add_label/:label_id',    action: 'add_label',    as: :add_label_to
      put 'remove_label/:label_id', action: 'remove_label', as: :remove_label_from
    end

    collection do
      get 'inbox',           action: 'index', filter: 'inbox'
      get 'assigned_to_you', action: 'index', filter: 'assigned_to_you'
      get 'reported_by_you', action: 'index', filter: 'reported_by_you'
      get 'unassigned',      action: 'index', filter: 'unassigned'
      get 'open',            action: 'index', filter: 'open'
      get 'closed',          action: 'index', filter: 'closed'
    end

    resources :labels, except: [:index, :edit, :update]
    resources :comments, only: [:create]
  end

  # You can have the root of your site routed with "root"
  root 'reports#index', filter: 'inbox'

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
