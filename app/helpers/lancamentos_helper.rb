module LancamentosHelper
  def caixa_series_query(dt)
    caixa_series_part1 = Lancamento.receitas.quitados.acao_este_ano(dt).acao_por_mes.select { sum(valor).as(valor) }.select { date_part('month', dataacao).as(mes) }
    caixa_series_part2 = Lancamento.despesas.quitados.acao_este_ano(dt).acao_por_mes.select { sum(valor).as(valor) }.select { date_part('month', dataacao).as(mes) }

    return "SELECT (COALESCE(r.valor,0)-COALESCE(d.valor,0)) as valor, r.mes as mes
            from (#{caixa_series_part1.to_sql}) r
            FULL JOIN (#{caixa_series_part2.to_sql}) d ON r.mes = d.mes"
  end

  def receita_series_query (dt)
    receita_series_part1 = Lancamento.validos.receitas.parcelamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }


    receita_series_part2 = Lancamento.validos.receitas.lancamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    meta_series = Target.receitas.por_mes.este_ano(dt)
      .select { sum(valor).as(valor) }
      .select { date_part('month', data).as(mes) }

    return "SELECT realizado.valor as valor, COALESCE(realizado.mes, meta.mes) as mes, meta.valor as meta from ((#{receita_series_part1.to_sql})
                    UNION (#{receita_series_part2.to_sql})) as realizado
                    RIGHT JOIN (SELECT COALESCE(m1.mes,m2.number) as mes, m1.valor as valor
                                FROM (#{meta_series.to_sql}) m1 RIGHT JOIN months m2 on m1.mes = m2.number) as meta on realizado.mes = meta.mes order by meta.mes"

  end

  def despesa_series_query (dt)
    despesa_series_part1 = Lancamento.despesas.parcelamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    despesa_series_part2 = Lancamento.despesas.lancamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    meta_series = Target.despesas.por_mes.este_ano(dt).select { sum(valor).as(valor) }.select { date_part('month', data).as(mes) }

    return "SELECT realizado.valor as valor, COALESCE(realizado.mes, meta.mes) as mes, meta.valor as meta from ((#{despesa_series_part1.to_sql})
                    UNION (#{despesa_series_part2.to_sql})) as realizado
                    RIGHT JOIN (SELECT COALESCE(m1.mes,m2.number) as mes, m1.valor as valor
                                FROM (#{meta_series.to_sql}) m1 RIGHT JOIN months m2 on m1.mes = m2.number) as meta on realizado.mes = meta.mes order by meta.mes"

  end
# ******************************************************************************************************************************

        # FLUXO DE CAIXA - RECEITAS

# ******************************************************************************************************************************
  def fluxo_caixa_receitas_vendas_realizado(inicio, fim)

    sql = Lancamento.receitas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.sales_category_code).subtree_ids)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_receitas_vendas_projetado(inicio, fim)
    sql = Lancamento.receitas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.sales_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_receitas_financeiras_realizado(inicio, fim)
    sql = Lancamento.receitas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.finance_category_code).subtree_ids)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_receitas_financeiras_projetado(inicio, fim)
    sql = Lancamento.receitas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.finance_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }.select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_receitas_outros_realizado(inicio, fim)
    receita_categories = Category.find_by_code(Configurable.sales_category_code).subtree_ids + Category.find_by_code(Configurable.finance_category_code).subtree_ids
    other_categories = Category.pluck(:id)- receita_categories

    sql = Lancamento.receitas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => other_categories)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_receitas_outros_projetado(inicio, fim)
    receita_categories = Category.find_by_code(Configurable.sales_category_code).subtree_ids + Category.find_by_code(Configurable.finance_category_code).subtree_ids
    other_categories = Category.pluck(:id)- receita_categories


    sql = Lancamento.receitas.validos.por_mes.range(inicio, fim)
    .where(:category_id => other_categories)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  # ******************************************************************************************************************************

  # FLUXO DE CAIXA - DESPESAS

  # ******************************************************************************************************************************
  def fluxo_caixa_despesas_administrativas_realizado(inicio, fim)

    sql = Lancamento.despesas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.administrative_category_code).subtree_ids)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_administrativas_projetado(inicio, fim)

    sql = Lancamento.despesas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.administrative_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_producao_realizado(inicio, fim)

    sql = Lancamento.despesas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.production_category_code).subtree_ids)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_producao_projetado(inicio, fim)

    sql = Lancamento.despesas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.production_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_financeiras_realizado(inicio, fim)

    sql = Lancamento.despesas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.finance_category_code).subtree_ids)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_financeiras_projetado(inicio, fim)

    sql = Lancamento.despesas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.finance_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_investimentos_realizado(inicio, fim)

    sql = Lancamento.despesas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.investment_category_code).subtree_ids)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_investimentos_projetado(inicio, fim)

    sql = Lancamento.despesas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.investment_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_outros_realizado(inicio, fim)
    despesas_categories = Category.find_by_code(Configurable.administrative_category_code).subtree_ids + Category.find_by_code(Configurable.finance_category_code).subtree_ids + Category.find_by_code(Configurable.production_category_code).subtree_ids + Category.find_by_code(Configurable.investment_category_code).subtree_ids
    other_categories = Category.pluck(:id)- despesas_categories

    sql = Lancamento.despesas.quitados.acao_por_mes.acao_range(inicio, fim)
    .where(:category_id => other_categories)
    .select { date_part('month', dataacao).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def fluxo_caixa_despesas_outros_projetado(inicio, fim)
    despesas_categories = Category.find_by_code(Configurable.administrative_category_code).subtree_ids + Category.find_by_code(Configurable.finance_category_code).subtree_ids + Category.find_by_code(Configurable.production_category_code).subtree_ids + Category.find_by_code(Configurable.investment_category_code).subtree_ids
    other_categories = Category.pluck(:id)- despesas_categories

    sql = Lancamento.despesas.validos.por_mes.range(inicio, fim)
    .where(:category_id => other_categories)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  # ******************************************************************************************************************************

  # DRE - RECEITAS

  # ******************************************************************************************************************************
  def resultados_receitas_vendas(inicio,fim)
    return fluxo_caixa_receitas_vendas_projetado(inicio,fim)
  end

  def resultados_receitas_outros(inicio, fim)
    return fluxo_caixa_receitas_outros_projetado(inicio,fim)
  end

  def resultados_receitas_financeiras(inicio,fim)
    return fluxo_caixa_receitas_financeiras_projetado(inicio,fim)
  end


  # ******************************************************************************************************************************

  # DRE - DESPESAS

  # ******************************************************************************************************************************
  def resultados_despesas_producao(inicio,fim)
    return fluxo_caixa_despesas_producao_projetado(inicio,fim)
  end

  def resultados_despesas_administrativas(inicio,fim)
    return fluxo_caixa_despesas_administrativas_projetado(inicio,fim)
  end

  def resultados_despesas_vendas(inicio,fim)
    sql = Lancamento.despesas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.sales_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end

  def resultados_despesas_financeiras(inicio,fim)
    return fluxo_caixa_despesas_financeiras_projetado(inicio,fim)
  end

  def resultados_despesas_impostos(inicio,fim)
    sql = Lancamento.despesas.validos.por_mes.range(inicio, fim)
    .where(:category_id => Category.find_by_code(Configurable.tax_category_code).subtree_ids)
    .select { date_part('month', datavencimento).as(mes) }
    .select{sum(valor).as(value)}.to_sql

    return "SELECT COALESCE(q.mes, m.number) as mes, COALESCE(q.value,0) AS value FROM (" + sql + ") q RIGHT JOIN months m ON q.mes = m.number"
  end



  #def fluxo_caixa_receitas_report(inicio, fim)
  #  dt = DateTime.now
  #
  #  top_projetados_sql = (Lancamento.receitas.validos.por_categoria.por_mes.range(inicio, fim)
  #  .joins { category }.group { category.descricao }
  #  .where(:category_id => Category.cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { category.descricao.as(descricao) }
  #  .select { date_part('month', datavencimento).as(mes) }).to_sql
  #
  #  outros_projetados_sql = (Lancamento.receitas.validos.por_mes.range(inicio, fim)
  #  .joins { category }
  #  .where(:category_id => Category.no_cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { "'outros' as descricao" }
  #  .select { date_part('month', datavencimento).as(mes) }).to_sql
  #
  #  projetado_sql = "(#{top_projetados_sql}) UNION (#{outros_projetados_sql}) "
  #
  #  top_realizados_sql = (Lancamento.receitas.quitados.por_categoria.acao_por_mes.acao_range(inicio, fim)
  #  .joins { category }.group { category.descricao }
  #  .where(:category_id => Category.cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { category.descricao.as(descricao) }
  #  .select { date_part('month', dataacao).as(mes) }).to_sql
  #
  #  outros_realizados_sql = (Lancamento.receitas.quitados.acao_por_mes.acao_range(inicio, fim)
  #  .joins { category }
  #  .where(:category_id => Category.no_cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { "'outros' as descricao" }
  #  .select { date_part('month', dataacao).as(mes) }).to_sql
  #
  #  realizado_sql = "(#{top_realizados_sql}) UNION (#{outros_realizados_sql})  "
  #
  #  fluxo_caixa_sql = "SELECT COALESCE(realizado.mes, projetado.mes) as mes, COALESCE(realizado.descricao, projetado.descricao) AS descricao,
  #            COALESCE(realizado.values,0) as realizado, COALESCE(projetado.values,0) as projetado
  #            FROM (#{realizado_sql}) realizado
  #            FULL OUTER JOIN (#{projetado_sql}) projetado ON realizado.mes = projetado.mes and realizado.descricao = projetado.descricao
  #            ORDER BY mes, descricao"
  #
  #
  #  return fluxo_caixa_sql
  #end
  #
  #def fluxo_caixa_despesas_report(inicio, fim)
  #  dt = DateTime.now
  #
  #  top_projetados_sql = (Lancamento.despesas.validos.por_categoria.por_mes.range(inicio, fim)
  #  .joins { category }.group { category.descricao }
  #  .where(:category_id => Category.cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { category.descricao.as(descricao) }
  #  .select { date_part('month', datavencimento).as(mes) }).to_sql
  #
  #  outros_projetados_sql = (Lancamento.despesas.validos.por_mes.range(inicio, fim)
  #  .joins { category }
  #  .where(:category_id => Category.no_cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { "'outros' as descricao" }
  #  .select { date_part('month', datavencimento).as(mes) }).to_sql
  #
  #  projetado_sql = "(#{top_projetados_sql}) UNION (#{outros_projetados_sql}) "
  #
  #  top_realizados_sql = (Lancamento.despesas.quitados.por_categoria.acao_por_mes.acao_range(inicio, fim)
  #  .joins { category }.group { category.descricao }
  #  .where(:category_id => Category.cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { category.descricao.as(descricao) }
  #  .select { date_part('month', dataacao).as(mes) }).to_sql
  #
  #  outros_realizados_sql = (Lancamento.despesas.quitados.acao_por_mes.acao_range(inicio, fim)
  #  .joins { category }
  #  .where(:category_id => Category.no_cash_flow_flag)
  #  .order("sum(valor) desc")
  #  .select { sum(valor).as(values) }
  #  .select { "'outros' as descricao" }
  #  .select { date_part('month', dataacao).as(mes) }).to_sql
  #
  #  realizado_sql = "(#{top_realizados_sql}) UNION (#{outros_realizados_sql})  "
  #
  #  fluxo_caixa_sql = "SELECT COALESCE(realizado.mes, projetado.mes) as mes, COALESCE(realizado.descricao, projetado.descricao) AS descricao,
  #            COALESCE(realizado.values,0) as realizado, COALESCE(projetado.values,0) as projetado
  #            FROM (#{realizado_sql}) realizado
  #            FULL OUTER JOIN (#{projetado_sql}) projetado ON realizado.mes = projetado.mes and realizado.descricao = projetado.descricao
  #            ORDER BY mes, descricao"
  #
  #
  #  return fluxo_caixa_sql
  #end


  def receita_report_series_query(dt)
    return Lancamento.receitas.este_ano(dt).por_mes
  end

  def despesa_report_series_query(dt)
    return Lancamento.despesas.este_ano(dt).por_mes
  end

  def meta_receita_report_series_query(dt)
    return Target.receitas.este_ano(dt).por_mes
  end

  def meta_despesa_report_series_query(dt)
    return Target.despesas.este_ano(dt).por_mes
  end

  #def receita_por_categoria_series_query(dt)
  #  return Lancamento.receitas.por_categoria.este_ano(dt)
  #  .joins { category }.group { category.descricao }
  #  .select { sum(valor).as(values) }
  #  .select { category.descricao.as(axis) }
  #end


  def receita_por_categoria_series_query(dt)
    #return Lancamento.receitas.por_categoria.este_ano(dt)
    #.joins { category }.group { category.descricao }.group{category_id }
    #.select { category_id.as(cat_id) }
    #.select { sum(valor).as(values) }
    #.select { category.descricao.as(axis) }

    #categories = Category.roots.select{id}.select{descricao}.select{ancestry}.to_sql
    #top_lancamentos_por_categoria = Lancamento.receitas.por_categoria.este_ano(dt).select{category_id}.select{sum(valor).as(values)}.order("sum(valor)").limit(Configurable.number_top_categories).to_sql
    #return "SELECT cat.id as cat_id, COALESCE(lan.values,0) as values, cat.descricao as axis FROM (#{categories}) cat LEFT JOIN (#{lancamentos_por_categoria}) lan ON cat.id = lan.category_id "

    return Lancamento.receitas.validos.por_categoria.este_ano(dt)
        .joins{ category }.group{ category.descricao }
        .select{ category.descricao.as(axis) }.select{ sum(valor).as(values) }.to_sql

  end

  def receita_por_status_series_query(dt)
    return Lancamento.receitas.por_status.este_ano(dt).group { status_cd }
    .select { sum(valor).as(values) }
    .select { "CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis" }
  end

  def despesa_por_categoria_series_query(dt)
    return Lancamento.despesas.validos.por_categoria.este_ano(dt)
    .joins{ category }.group{ category.descricao }
    .select{ category.descricao.as(axis) }.select{ sum(valor).as(values) }
    .select{ category_id }.to_sql

  end

  def despesa_por_centrodecusto_series_query(dt)
    return Lancamento.despesas.por_centrodecusto.este_ano(dt).joins { centrodecusto }.group { centrodecusto.descricao }
    .select { sum(valor).as(values) }
    .select { centrodecusto.descricao.as(axis) }
  end

  def despesa_por_status_series_query(dt)
    return Lancamento.despesas.por_status.este_mes(dt).group { status_cd }
    .select { sum(valor).as(values) }
    .select { "CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis" }
  end

  def convert_status_to_case_query
    return 'CASE WHEN status_cd=0 THEN aberto
                WHEN status_cd=1 THEN quitado
                WHEN status_cd=2 THEN estornado
                WHEN status_cd=3 THEN cancelado
            END'
    #as_enum :status, [:aberto, :quitado, :estornado, :cancelado]
  end

  # Graficos e relatorios diversos
  # **********************************************************************************************************
  # Receitas
  # **********************************************************************************************************
  def contas_a_receber_report_table (inicio, fim)
    today = DateTime.now

    inicio = today unless inicio > today
    return Lancamento.abertos.receitas.range(inicio, fim)
          .select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
          .order("datavencimento")
  end

  def recebimentos_atrasados_report_table (inicio, fim)
    today = DateTime.now
    return Lancamento.abertos.receitas.range(inicio, today).order("datavencimento").select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
  end


  def top_receitas_report_table (inicio, fim)
    return Lancamento.receitas.range(inicio, fim).order("valor desc").limit(Configurable.number_of_top_records).select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
  end

  def receitas_por_categoria_report_table(inicio, fim)
    root_categories = Category.roots.pluck(:id)
    child_categories = Category.pluck(:id)-root_categories

    return Lancamento.receitas.validos.range(inicio,fim).joins{ category }
    .group{ category.id }.group{ datavencimento }.group{ descricao }
    .where( :category_id => child_categories )
    .select{sum(valor).as(values)}.select{category.descricao.as(axis)}
    .select{datavencimento.as(dateselected)}.select{ descricao }.order("axis")
  end

  def receitas_por_categoria_parent_report_table(inicio, fim)
    root_categories = Category.roots.pluck(:id)
    child_categories = Category.pluck(:id)-root_categories

    sub_categories = Lancamento.receitas.validos.range(inicio,fim).joins{ category }
      .group{ category.ancestry }.group{ datavencimento }.group{ descricao }
      .where( :category_id => child_categories )
      .select{sum(valor).as(values)}.select{category.ancestry.as(parent)}
      .select{datavencimento.as(dateselected)}.select{ descricao }
    parent_categories = Lancamento.receitas.validos.range(inicio,fim).joins{ category }
      .group{ category.id }.group{ datavencimento }.group{ descricao }
      .where(:category_id => root_categories)
      .select{sum(valor).as(values)}.select{"cast(categories.id as varchar) as parent"}
      .select{datavencimento.as(dateselected)}.select{ descricao }

    return "(#{parent_categories.to_sql}) UNION (#{sub_categories.to_sql}) order by parent"
  end

  def receitas_por_status_report_table(inicio, fim)
    return Lancamento.receitas.por_status.range(inicio, fim).group { status_cd }.group { valor }.group { descricao }.group { datavencimento }
    .select { valor.as(values) }
    .select { "CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis" }.select { descricao }.select { datavencimento.as(dateselected) }.order("axis")
  end

  def receitas_por_centrodecusto_report_table(inicio, fim)
    #dt = DateTime.now
    #return Lancamento.receitas.por_centrodecusto.este_mes(dt).joins { centrodecusto }.group { centrodecusto.descricao }.group{valor}.group{descricao}.group{datavencimento}
    return Lancamento.receitas.por_centrodecusto.range(inicio, fim).joins { centrodecusto }.group { centrodecusto.descricao }.group { valor }.group { descricao }.group { datavencimento }
    .select { valor.as(values) }.select { centrodecusto.descricao.as(axis) }.select { descricao }.select { datavencimento.as(dateselected) }.order("axis").order("valor desc")
  end

  def prazo_medio_recebimento_report(inicio, fim)

    query = Lancamento.receitas.range(inicio, fim).quitados.por_mes
      .select { round(avg(dataacao-datavencimento)).as(values) }
      .select { date_part('month', datavencimento).as(axis) }.order("axis")

    return "SELECT q1.values as values, COALESCE(q1.axis, m.number) as axis FROM (#{query.to_sql}) q1 RIGHT JOIN months m on q1.axis = m.number"
  end

  def ticket_medio_vendas_report(inicio, fim)
    query = Lancamento.receitas.range(inicio, fim).por_mes.select { avg(valor).as(values) }.select { date_part('month', datavencimento).as(axis) }

    return "SELECT q1.values as values, COALESCE(q1.axis, m.number) as axis FROM (#{query.to_sql}) q1 RIGHT JOIN months m on q1.axis = m.number"
  end

  # **********************************************************************************************************

  # **********************************************************************************************************
  # Despesas
  # **********************************************************************************************************

  def contas_a_pagar_report_table(inicio,fim)
    today = DateTime.now

    inicio = today unless inicio > today
    return Lancamento.abertos.despesas.range(inicio, fim)
      .select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
      .order("datavencimento")
  end

  def contas_vencidas_report_table(inicio,fim)
    today = DateTime.now
    return Lancamento.abertos.despesas.range(inicio, today).order("datavencimento").select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
  end

  def top_despesas_report_table(inicio,fim)
    return Lancamento.despesas.range(inicio, fim).order("valor desc").limit(Configurable.number_of_top_records).select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
  end

  def despesas_por_categoria_report_table(inicio, fim)
    root_categories = Category.roots.pluck(:id)
    child_categories = Category.pluck(:id)-root_categories

    return Lancamento.despesas.validos.range(inicio,fim).joins{ category }
    .group{ category.id }.group{ datavencimento }.group{ descricao }
    .where( :category_id => child_categories )
    .select{sum(valor).as(values)}.select{category.descricao.as(axis)}
    .select{datavencimento.as(dateselected)}.select{ descricao }.order("axis")
  end

  def despesas_por_categoria_parent_report_table(inicio, fim)
    root_categories = Category.roots.pluck(:id)
    child_categories = Category.pluck(:id)-root_categories

    sub_categories = Lancamento.despesas.validos.range(inicio,fim).joins{ category }
    .group{ category.ancestry }.group{ datavencimento }.group{ descricao }
    .where( :category_id => child_categories )
    .select{sum(valor).as(values)}.select{category.ancestry.as(parent)}
    .select{datavencimento.as(dateselected)}.select{ descricao }
    parent_categories = Lancamento.receitas.validos.range(inicio,fim).joins{ category }
    .group{ category.id }.group{ datavencimento }.group{ descricao }
    .where(:category_id => root_categories)
    .select{sum(valor).as(values)}.select{"cast(categories.id as varchar) as parent"}
    .select{datavencimento.as(dateselected)}.select{ descricao }

    return "(#{parent_categories.to_sql}) UNION (#{sub_categories.to_sql}) order by parent"
  end

  def despesas_por_status_report_table(inicio, fim)
    return Lancamento.despesas.por_status.range(inicio, fim).group { status_cd }.group { valor }.group { descricao }.group { datavencimento }
    .select { valor.as(values) }
    .select { "CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis" }.select { descricao }.select { datavencimento.as(dateselected) }.order("axis")
  end

  def despesas_por_centrodecusto_report_table(inicio, fim)
    return Lancamento.despesas.por_centrodecusto.range(inicio, fim).joins { centrodecusto }.group { centrodecusto.descricao }.group { valor }.group { descricao }.group { datavencimento }
    .select { valor.as(values) }.select { centrodecusto.descricao.as(axis) }.select { descricao }.select { datavencimento.as(dateselected) }.order("axis").order("valor desc")
  end

  def prazo_medio_pagamento_report(inicio, fim)

    query = Lancamento.despesas.range(inicio, fim).quitados.por_mes
    .select { round(avg(dataacao-datavencimento)).as(values) }
    .select { date_part('month', datavencimento).as(axis) }.order("axis")

    return "SELECT q1.values as values, COALESCE(q1.axis, m.number) as axis FROM (#{query.to_sql}) q1 RIGHT JOIN months m on q1.axis = m.number"
  end

  def ticket_medio_pagamento_report
    dt = DateTime.now
    return Lancamento.receitas.este_ano(dt).por_mes.select { avg(valor).as(values) }.select { date_part('month', datavencimento).as(axis) }
  end

  def aderencia_report(inicio,fim)
    dt = DateTime.now
    aderencia_report_part1 = Lancamento.receitas.range(inicio,fim).por_mes
                .select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }
    aderencia_report_part2 = Lancamento.despesas.range(inicio,fim).por_mes
                .select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }

    meta_series_part1 = Target.receitas.por_mes.este_ano(dt)
              .select { sum(valor).as(valor) }.select { date_part('month', data).as(mes) }
    meta_series_part2 = Target.despesas.por_mes.este_ano(dt)
              .select { sum(valor).as(valor) }.select { date_part('month', data).as(mes) }

    aderencia_report = "SELECT ((COALESCE(r.valor,0))/(CASE d.valor WHEN 0 THEN 1 ELSE COALESCE(d.valor,1) END)) as values, r.mes as axis
            FROM (#{aderencia_report_part1.to_sql}) r
            FULL JOIN (#{aderencia_report_part2.to_sql}) d ON r.mes = d.mes"
    meta_report = "SELECT ((COALESCE(r.valor,0))/(CASE d.valor WHEN 0 THEN 1 ELSE COALESCE(d.valor,1) END)) as values, r.mes as axis
            FROM (#{meta_series_part1.to_sql}) r
            FULL JOIN (#{meta_series_part2.to_sql}) d ON r.mes = d.mes"

    return "SELECT a.values*100 as values, COALESCE(a.axis,mon.number) as axis, m.values*100 as meta
            FROM (#{aderencia_report}) a
            INNER JOIN (#{meta_report}) m ON a.axis = m.axis
            RIGHT JOIN months mon ON a.axis = mon.number"
  end

  def ultimos_lancamentos_report
    return Lancamento.abertos.order("created_at desc").limit(Configurable.number_of_top_records).select { created_at }.select { valor }.select { datavencimento }.select { descricao }
  end

  def lancamentos_futuros_report
    today = DateTime.now
    dt = DateTime.now + (Configurable.number_of_future_days).days
    lancamentos_futuros_part_1 = Lancamento.receitas.abertos.range(today, dt).por_mes.select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }
    lancamentos_futuros_part_2 = Lancamento.despesas.abertos.range(today, dt).por_mes.select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }

    return "SELECT 5 as mes,0 as receitas,0 as despesas UNION  SELECT COALESCE(r.mes,d.mes) as mes, COALESCE(r.valor,0) as receitas, COALESCE(d.valor,0) as despesas
              FROM (#{lancamentos_futuros_part_1.to_sql}) as r
              FULL JOIN (#{lancamentos_futuros_part_2.to_sql}) as d ON r.mes = d.mes ORDER BY mes"
  end


end

# **********************************************************************************************************************
# Classes de suporte
#
# **********************************************************************************************************************
class CaixaMes
  def realizado
    realizado
  end

  def realizado=(valor)
    realizado=valor
  end

  def projetado
    projetado
  end

  def projetado=(valor)
    projetado=valor
  end
end
