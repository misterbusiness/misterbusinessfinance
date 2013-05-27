namespace :db do
  desc 'Erase and fill database'
  task :populate => :environment do
    require 'populator'
    [Category, Centrodecusto, Lancamentorapido, Lancamento].each(&:delete_all)

    Category.populate 1 do |categoryBase|
      categoryBase.descricao = 'Sem categoria'
    end

    Centrodecusto.populate 1 do |categoryBase|
      categoryBase.descricao = 'Sem centro de custo'
    end


    Category.populate 6 do |category|
      category.descricao = Faker::Company.name
    end
    Centrodecusto.populate 5 do |centrodecusto|
      centrodecusto.descricao = Faker::Company.name
    end

    Lancamento.populate 30 do |lancamento|
      lancamento.descricao = Populator.words(1..3)
      lancamento.status_cd = [Lancamento.aberto]
      lancamento.tipo_cd = [Lancamento.receita, Lancamento.despesa]
      lancamento.datavencimento = 5.months.ago..Time.now
      lancamento.valor = 1..99999
      lancamento.created_at = 5.months.ago..Time.now
      lancamento.category_id = 1..7
      lancamento.centrodecusto_id = 1..6
    end

    Lancamentorapido.populate 10 do |lancamentorapido|
      lancamentorapido.descricao = Populator.words(1)
      lancamentorapido.tipo_cd = [Lancamento.receita, Lancamento.despesa]
      lancamentorapido.diavencimento = 1.31
      lancamentorapido.valor = 1..99999
      lancamentorapido.created_at = 5.months.ago..Time.now
      lancamentorapido.category_id = 1..7
      lancamentorapido.centrodecusto_id = 1..6
    end
  end
end