namespace :db do
  desc 'Erase and fill database'
  task :populate => :environment do
    require 'populator'
    [Category, Centrodecusto, Lancamentorapido, Lancamento, Target, Months].each(&:delete_all)

    # Zera o sequence da categoria
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE public.categories_id_seq RESTART 1')
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE public.centrodecustos_id_seq RESTART 1')

    @month = 1
    Months.populate 12 do |month|
      month.number = @month
      @month = @month + 1
    end

    Category.populate 1 do |categoryBase|
      categoryBase.descricao = 'Sem categoria'
      categoryBase.is_cash_flow = true
    end

    Category.populate 1 do |categoryBase|
       categoryBase.descricao = 'Venda'
       categoryBase.code = Configurable.sales_category_code

    end

    Category.populate 1 do |categoryBase|
      categoryBase.descricao = 'Financeiro'
      categoryBase.code = Configurable.finance_category_code
    end

    Category.populate 1 do |categoryBase|
      categoryBase.descricao = 'Administrativo'
      categoryBase.code = Configurable.administrative_category_code
#      categoryBase.is_cash_flow = false
    end

    Category.populate 1 do |categoryBase|
      categoryBase.descricao = 'Produzir'
      categoryBase.code = Configurable.production_category_code
#      categoryBase.is_cash_flow = false
    end

    Category.populate 1 do |categoryBase|
      categoryBase.descricao = 'Investimento'
      categoryBase.code = Configurable.investment_category_code
#      categoryBase.is_cash_flow = false
    end

    Category.populate 1 do |categoryBase|
      categoryBase.descricao = 'Impostos'
      categoryBase.code = Configurable.tax_category_code
#      categoryBase.is_cash_flow = false
    end

    Centrodecusto.populate 1 do |categoryBase|
      categoryBase.descricao = 'Sem centro de custo'
    end

    Category.populate 2 do |category|
      category.descricao = Faker::Company.name
      category.is_cash_flow = true
      category.ancestry = 2
    end

    Category.populate 3 do |category|
      category.descricao = Faker::Company.name
      category.is_cash_flow = false
      category.ancestry = 3
    end

    Category.populate 3 do |category|
      category.descricao = Faker::Company.name
      category.is_cash_flow = false
      category.ancestry = 4
    end

    Category.populate 2 do |category|
      category.descricao = Faker::Company.name
      category.is_cash_flow = false
      category.ancestry = 5
    end

    Category.populate 2 do |category|
      category.descricao = Faker::Company.name
      category.is_cash_flow = false
      category.ancestry = 6
    end

    Centrodecusto.populate 5 do |centrodecusto|
      centrodecusto.descricao = Faker::Company.name
    end

    Lancamento.populate 400 do |lancamento|
      lancamento.descricao = Populator.words(1..3)
      lancamento.status_cd = [Lancamento.aberto]
      lancamento.tipo_cd = [Lancamento.receita, Lancamento.despesa]
      lancamento.datavencimento = 3.years.ago..2.years.from_now
      lancamento.valor = 1..99
      lancamento.created_at = 3.years.ago..Time.now #5.months.ago..Time.now
      lancamento.category_id = 1..12
      lancamento.centrodecusto_id = 1..6
    end

    Lancamento.populate 200 do |lancamento|
      lancamento.descricao = Populator.words(1..3)
      lancamento.status_cd = [Lancamento.quitado]
      lancamento.tipo_cd = [Lancamento.receita, Lancamento.despesa]
      lancamento.datavencimento = 3.years.ago..2.years.from_now
      lancamento.valor = 1..99
      lancamento.created_at = 3.years.ago..Time.now #5.months.ago..Time.now
      lancamento.category_id = 1..12
      lancamento.centrodecusto_id = 1..6
      lancamento.dataacao = 3.years.ago..Time.now
    end

    Lancamentorapido.populate 10 do |lancamentorapido|
      lancamentorapido.descricao = Populator.words(1)
      lancamentorapido.tipo_cd = [Lancamento.receita, Lancamento.despesa]
      lancamentorapido.diavencimento = 1.31
      lancamentorapido.valor = 1..99999
      lancamentorapido.created_at = 5.months.ago..Time.now
      lancamentorapido.category_id = 1..12
      lancamentorapido.centrodecusto_id = 1..6
    end

    @index = 1
    Target.populate 12 do |target|
      target.descricao = Populator.words(1)
      target.tipo_cd = [Target.receita]
      target.data = DateTime.new(Time.now.year, @index, 1)
      target.valor = 1..99
      @index = @index + 1
    end

    @index = 1
    Target.populate 12 do |target|
      target.descricao = Populator.words(1)
      target.tipo_cd = [Target.despesa]
      target.data = DateTime.new(Time.now.year, @index, 1)
      target.valor = 1..99
      @index = @index + 1
    end
  end
end