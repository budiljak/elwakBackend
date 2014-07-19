ElwakBackend::Application.routes.draw do
  resources :checklisten_vorlages

  resources :schichts

  resources :infos

  resources :info_empfaengers

  resources :objekts

  resources :benutzers
  
  get "sync/allgemein" => 'sync#allgemein'
  get "sync/benutzer" => 'sync#benutzer'
  get "sync/objekt" => 'sync#objekt'

  post "pdf_dateis/:art/:objekt_id" => 'pdf_datei#upload'
  post "pdf_dateis/:art" => 'pdf_datei#upload'
  delete "pdf_dateis/:art/:objekt_id" => 'pdf_datei#loeschen'
  delete "pdf_dateis/:art" => 'pdf_datei#loeschen'
  get "pdf_dateis/" => 'pdf_datei#index'
  get "pdf_dateis/:id" => 'pdf_datei#download'

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