Misterbusinessfinance::Application.routes.draw do
   

  # Reports - Lançamentos
  match 'lancamentos/reports/receita_realizada', to: 'reports#receita_realizada'

  match 'lancamentos/reports/despesa_realizada', to: 'reports#despesa_realizada'

  match 'lancamentos/reports/receita_por_categoria', to: 'reports#receita_por_categoria'

  match 'lancamentos/reports/despesa_por_categoria', to: 'reports#despesa_por_categoria'

  match 'lancamentos/reports/receita_por_status', to: 'reports#receita_por_status'

  match 'lancamentos/reports/despesa_por_centrodecusto', to: 'reports#despesa_por_centrodecusto'

  #Reports
  match 'lancamentos/reports/contas_a_receber_chart', to: 'reports#contas_a_receber_chart'
  match 'lancamentos/reports/contas_a_receber_table', to: 'reports#contas_a_receber_table'

  match 'lancamentos/reports/recebimentos_atrasados_chart', to: 'reports#recebimentos_atrasados_chart'
  match 'lancamentos/reports/recebimentos_atrasados_table', to: 'reports#recebimentos_atrasados_table'

  match 'lancamentos/reports/top_receitas_chart', to: 'reports#top_receitas_chart'
  match 'lancamentos/reports/top_receitas_table', to: 'reports#top_receitas_table'


  resources :targets

  resources :lancamentorapidos

  resources :centrodecustos

  resources :categories  
  
  resources :lancamentos do
     member do
       put :quitar
       put :estornar
       put :destroy
     end
  end
  resources :lancamentos   
    
  


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

    match 'lancamentos/quitar' => 'lancamentos#quitar'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'lancamentos#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
