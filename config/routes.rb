Misterbusinessfinance::Application.routes.draw do
   

  # Reports - Estatisticas
  match 'lancamentos/reports/receita_estatisticas', to: 'reports#receita_estatisticas'
  match 'lancamentos/reports/despesa_estatisticas', to: 'reports#despesa_estatisticas'
  match 'lancamentos/reports/fluxo_caixa_estatisticas', to: 'reports#fluxo_caixa_estatisticas'


  # Reports - Lançamentos
  match 'lancamentos/reports/receita_realizada', to: 'reports#receita_realizada'

  match 'lancamentos/reports/despesa_realizada', to: 'reports#despesa_realizada'

  match 'lancamentos/reports/receita_por_categoria', to: 'reports#receita_por_categoria'

  match 'lancamentos/reports/despesa_por_categoria', to: 'reports#despesa_por_categoria'

  match 'lancamentos/reports/receita_por_status', to: 'reports#receita_por_status'

  match 'lancamentos/reports/despesa_por_centrodecusto', to: 'reports#despesa_por_centrodecusto'

  #Reports
  # ******************************************************************************************************
  # Receita
  # ******************************************************************************************************

  match 'lancamentos/reports/contas_a_receber_chart', to: 'reports#contas_a_receber_chart'
  match 'lancamentos/reports/contas_a_receber_table', to: 'reports#contas_a_receber_table'

  match 'lancamentos/reports/recebimentos_atrasados_chart', to: 'reports#recebimentos_atrasados_chart'
  match 'lancamentos/reports/recebimentos_atrasados_table', to: 'reports#recebimentos_atrasados_table'

  match 'lancamentos/reports/top_receitas_chart', to: 'reports#top_receitas_chart'
  match 'lancamentos/reports/top_receitas_table', to: 'reports#top_receitas_table'

  match 'lancamentos/reports/receitas_por_categoria_chart', to: 'reports#receitas_por_categoria_chart'
  match 'lancamentos/reports/receitas_por_categoria_table', to: 'reports#receitas_por_categoria_table'

  match 'lancamentos/reports/receitas_por_status_table', to: 'reports#receitas_por_status_table'

  match 'lancamentos/reports/receitas_por_centrodecusto_table', to: 'reports#receitas_por_centrodecusto_table'

  match 'lancamentos/reports/prazo_medio_recebimento', to: 'reports#prazo_medio_recebimento'

  match 'lancamentos/reports/ticket_medio_vendas', to: 'reports#ticket_medio_vendas'

  # ******************************************************************************************************
  # Despesas
  # ******************************************************************************************************

  match 'lancamentos/reports/contas_a_pagar_chart', to: 'reports#contas_a_pagar_chart'
  match 'lancamentos/reports/contas_a_pagar_table', to: 'reports#contas_a_pagar_table'

  match 'lancamentos/reports/contas_vencidas_chart', to: 'reports#contas_vencidas_chart'
  match 'lancamentos/reports/contas_vencidas_table', to: 'reports#contas_vencidas_table'

  match 'lancamentos/reports/top_despesas_chart', to: 'reports#top_despesas_chart'
  match 'lancamentos/reports/top_despesas_table', to: 'reports#top_despesas_table'

  match 'lancamentos/reports/despesas_por_categoria_chart', to: 'reports#despesas_por_categoria_chart'
  match 'lancamentos/reports/despesas_por_categoria_table', to: 'reports#despesas_por_categoria_table'

  match 'lancamentos/reports/despesas_por_status_table', to: 'reports#despesas_por_status_table'

  match 'lancamentos/reports/despesas_por_centrodecusto_table', to: 'reports#despesas_por_centrodecusto_table'

  match 'lancamentos/reports/prazo_medio_pagamento', to: 'reports#prazo_medio_pagamento'

  match 'lancamentos/reports/aderencia', to: 'reports#aderencia'

  # ******************************************************************************************************
  # Outros
  # ******************************************************************************************************

  match 'lancamentos/reports/ultimos_lancamentos_table', to: 'reports#ultimos_lancamentos_table'
  match 'lancamentos/reports/ultimos_lancamentos_chart', to: 'reports#ultimos_lancamentos_chart'

  match 'lancamentos/reports/lancamentos_futuros_table', to: 'reports#lancamentos_futuros_table'
  match 'lancamentos/reports/lancamentos_futuros_chart', to: 'reports#lancamentos_futuros_chart'

  match 'lancamentos/reports/lista_categorias', to: 'reports#lista_categorias'
  match 'lancamentos/reports/lista_centrodecustos', to: 'reports#lista_centrodecustos'

  match 'lancamentos/reports/ultimos_lancamentos', to: 'reports#ultimos_lancamentos'
  match 'lancamentos/reports/lancamentos_futuros', to: 'reports#lancamentos_futuros'
  match 'categories/reports/categories_lista', to: 'reports#categories_lista'
  match 'centrodecustos/reports/centrodecustos_lista', to: 'reports#centrodecustos_lista'

  # Print reports page
  match 'lancamentos/print', to: 'lancamentos#print'

  resources :targets

  resources :lancamentorapidos

  match 'list/lancamentosrapidos', to: 'lancamentorapidos#list'

  resources :centrodecustos
  match 'list/centrodecustos', to: 'centrodecustos#list'

  resources :categories
  match 'list/categories', to: 'categories#list'
  
  resources :lancamentos do
     member do
       put :quitar
       put :estornar
     end

    get :filter

  end
  resources :lancamentos

  resources :support do
    get :datestring
    #member do
    #  post :getdatestring
    #end
  end
  match 'support/datestring', to: 'support#datestring'
  


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)


    match 'filter' => 'lancamentos#filter'

    match 'getLancamento' => 'lancamentos#getLancamento'

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
