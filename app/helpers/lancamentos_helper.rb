module LancamentosHelper
  def caixa_series_query(dt)
    @caixa_series_part1 = Lancamento.receitas.quitados.este_ano(@dt).por_mes.select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }
    @caixa_series_part2 = Lancamento.despesas.quitados.este_ano(@dt).por_mes.select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }

    return "SELECT (COALESCE(r.valor,0)-COALESCE(d.valor,0)) as valor, r.mes as mes
            from (#{@caixa_series_part1.to_sql}) r
            FULL JOIN (#{@caixa_series_part2.to_sql}) d ON r.mes = d.mes"
  end

  def receita_series_query (dt)
    @receita_series_part1 = Lancamento.receitas.parcelamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }


    @receita_series_part2 = Lancamento.receitas.lancamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    @meta_serias = Target.receitas.por_mes.este_ano(dt).select{sum(valor).as(valor)}.select{date_part('month', data).as(mes) }

    return "SELECT realizado.valor as valor, realizado.mes, meta.valor as meta from ((#{@receita_series_part1.to_sql})
                    UNION (#{@receita_series_part2.to_sql})) as realizado
                    INNER JOIN (#{@meta_serias.to_sql}) as meta on realizado.mes = meta.mes order by mes"
  end

  def despesa_series_query (dt)
    @despesa_series_part1 = Lancamento.despesas.parcelamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    @despesa_series_part2 = Lancamento.despesas.lancamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    @meta_serias = Target.despesas.por_mes.este_ano(dt).select{sum(valor).as(valor)}.select{date_part('month', data).as(mes) }

    return "SELECT realizado.valor as valor, realizado.mes, meta.valor as meta from ((#{@despesa_series_part1.to_sql})
                    UNION (#{@despesa_series_part2.to_sql})) as realizado
                    INNER JOIN (#{@meta_serias.to_sql}) as meta on realizado.mes = meta.mes order by mes"
  end

  def fluxo_caixa_receitas_report
    @dt = DateTime.now
    @fluxo_caixa_sql = "SELECT * FROM ("
    # Itera por cada mes construindo a query
    (1..12).each do |mes|
      @inicio = DateTime.new(@dt.year,mes,01)
      @fim = @inicio.end_of_month

      @projetado_sql = get_fluxo_caixa_query(Lancamento.aberto, Lancamento.receita, @inicio, @fim)
      @realizado_sql = get_fluxo_caixa_query(Lancamento.quitado, Lancamento.receita, @inicio, @fim)

      @receita_sql = "SELECT #{mes} as mes, projetado.values as projetado, realizado.values as realizado, "
    end

    @fluxo_caixa_sql = "#{@fluxo_caixa_sql}) fluxo_caixa"

    return @fluxo_caixa_sql

  end

  def get_fluxo_caixa_query(status, tipo, inicio, fim)

    @top_categorias_sql = (Lancamento.por_categoria.range(inicio,fim).por_mes.
        joins { category }.group { category.descricao }
    .where(:category_id => Category.cash_flow_flag)
    .where(:status=>status)
    .where(:tipo_cd=>tipo)
    .order("sum(valor) desc")
    .select { sum(valor).as(values) }
    .select { category.descricao.as(descricao) }
    .select { date_part('month', datavencimento).as(mes)}).to_sql

    @other_categorias_sql = (Lancamento.range(inicio,fim).por_mes.
        joins { category }
    .where(:category_id => Category.no_cash_flow_flag)
    .where(:status=>status)
    .where(:tipo_cd=>tipo)
    .select { sum(valor).as(values) }
    .select { ("outros").as(descricao) }
    .select { date_part('month', datavencimento).as(mes)}).to_sql

#    @other_categorias_sql = "SELECT todas.total-top.total as values, 'outras' as descricao, todas.mes FROM
#                  (SELECT sum(values) as total, mes FROM (#{@top_categorias_sql}) top_categorias GROUP BY mes) top INNER JOIN
#                  (SELECT sum(values) as total, mes FROM (#{@all_categorias_sql}) todas_categorias GROUP BY mes) todas ON todas.mes = top.mes"

    return "(#{@top_categorias_sql}) UNION( #{@other_categorias_sql})"
  end

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

  def receita_por_categoria_series_query(dt)
    return Lancamento.receitas.por_categoria.este_ano(dt).joins { category }.group { category.descricao }
    .select { sum(valor).as(values) }
    .select { category.descricao.as(axis) }
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

#TODO: Queries alteradas para este_ano, por causa do volume de dados (voltar para este_mes depois)
  def despesa_por_categoria_series_query(dt)
    return Lancamento.despesas.por_categoria.este_ano(dt).joins { category }.group { category.descricao }
    .select { sum(valor).as(values) }
    .select { category.descricao.as(axis) }
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
    @today = DateTime.now
    #@dt = DateTime.now + (Configurable.number_of_days_range).days
    #return Lancamento.abertos.receitas.range(@today, @dt).order("datavencimento").select { valor.as(values) }.select { to_char(datavencimento, 'DD-MM').as(axis) }.select { descricao }
    #return Lancamento.abertos.receitas.range(@today, @dt).order("datavencimento").select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
    return Lancamento.abertos.receitas.range(@today, fim).order("datavencimento").select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
  end

  def recebimentos_atrasados_report_table (inicio, fim)
    @today = DateTime.now
    #@dt = DateTime.now - (Configurable.number_of_days_range).days
    #return Lancamento.abertos.receitas.range(@dt, @today).order("datavencimento").select { valor.as(values) }.select {datavencimento.as(axis) }.select { descricao }
    return Lancamento.abertos.receitas.range(inicio, @today).order("datavencimento").select { valor.as(values) }.select {datavencimento.as(axis) }.select { descricao }
  end


  def top_receitas_report_table (inicio, fim)
    #@dt = DateTime.now
    #return Lancamento.receitas.este_mes(@dt).order("valor desc").limit(Configurable.number_of_top_records).select{valor.as(values)}.select{datavencimento.as(axis)}.select{descricao}
    return Lancamento.receitas.range(inicio,fim).order("valor desc").limit(Configurable.number_of_top_records).select{valor.as(values)}.select{datavencimento.as(axis)}.select{descricao}
  end

  def receitas_por_categoria_report_table(inicio, fim)
    #@dt = DateTime.now
    #return Lancamento.receitas.por_categoria.este_mes(@dt).joins { category }.group{ category.descricao }.group{valor}.group{descricao}.group{datavencimento}.select{valor.as(values)}.select{category.descricao.as(axis)}.select{descricao}.select{datavencimento.as(dateselected)}.order("axis").order("valor desc")
    #return Lancamento.receitas.por_categoria.este_mes(dt).joins { category }.group{ category.descricao }.group{valor}.group{descricao}.group{datavencimento}.select{valor.as(values)}.select{category.descricao.as(axis)}.select{descricao}.select{datavencimento.as(dateselected)}.order("axis").order("valor desc")
    return Lancamento.receitas.por_categoria.range(inicio,fim).joins { category }.group{ category.descricao }.group{valor}.group{descricao}.group{datavencimento}.select{valor.as(values)}.select{category.descricao.as(axis)}.select{descricao}.select{datavencimento.as(dateselected)}.order("axis").order("valor desc")
  end

  def receitas_por_status_report_table(inicio, fim)
    #@dt = DateTime.now
    #return Lancamento.receitas.por_status.este_mes(@dt).group { status_cd }.group{valor}.group{descricao}.group{datavencimento}
    return Lancamento.receitas.por_status.range(inicio,fim).group { status_cd }.group{valor}.group{descricao}.group{datavencimento}
    .select { valor.as(values) }
    .select { "CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis" }.select{descricao}.select{datavencimento.as(dateselected)}.order("axis")
  end

  def receitas_por_centrodecusto_report_table(inicio, fim)
    #@dt = DateTime.now
    #return Lancamento.receitas.por_centrodecusto.este_mes(@dt).joins { centrodecusto }.group { centrodecusto.descricao }.group{valor}.group{descricao}.group{datavencimento}
    return Lancamento.receitas.por_centrodecusto.range(inicio,fim).joins { centrodecusto }.group { centrodecusto.descricao }.group{valor}.group{descricao}.group{datavencimento}
          .select{valor.as(values)}.select{centrodecusto.descricao.as(axis)}.select{descricao}.select{datavencimento.as(dateselected)}.order("axis").order("valor desc")
  end

  def prazo_medio_recebimento_report(inicio, fim)
    #@dt = DateTime.now
    #return Lancamento.receitas.este_ano(@dt).quitados.por_mes.select('AVG(dataacao-datavencimento) AS values').select { date_part('month', datavencimento).as(axis) }.order("axis")
    #return Lancamento.receitas.este_ano(@dt).quitados.por_mes.select{avg(dataacao-datavencimento).as(values)}.select { date_part('month', datavencimento).as(axis) }.order("axis")
    return Lancamento.receitas.range(inicio,fim).quitados.por_mes.select{avg(dataacao-datavencimento).as(values)}.select { date_part('month', datavencimento).as(axis) }.order("axis")
  end

  def ticket_medio_vendas_report(inicio, fim)
    #@dt = DateTime.now
    #return Lancamento.receitas.este_ano(@dt).por_mes.select {avg(valor).as(values) }.select { date_part('month', datavencimento).as(axis) }
    return Lancamento.receitas.range(inicio,fim).por_mes.select {avg(valor).as(values) }.select { date_part('month', datavencimento).as(axis) }
  end
  # **********************************************************************************************************

  # **********************************************************************************************************
  # Despesas
  # **********************************************************************************************************

  def contas_a_pagar_report_table
    @today = DateTime.now
    @dt = DateTime.now + (Configurable.number_of_days_range).days
    return Lancamento.abertos.despesas.range(@today, @dt).order("datavencimento").select { valor.as(values) }.select { datavencimento.as(axis) }.select { descricao }
  end

  def contas_vencidas_report_table
    @today = DateTime.now
    @dt = DateTime.now - (Configurable.number_of_days_range).days
    return Lancamento.abertos.despesas.range(@dt, @today).order("datavencimento").select { valor.as(values) }.select {datavencimento.as(axis) }.select { descricao }
  end

  def top_despesas_report_table
    @dt = DateTime.now
    return Lancamento.despesas.este_mes(@dt).order("valor desc").limit(Configurable.number_of_top_records).select{valor.as(values)}.select{datavencimento.as(axis)}.select{descricao}
  end

  def despesas_por_categoria_report_table
    @dt = DateTime.now
    return Lancamento.despesas.por_categoria.este_mes(@dt).joins { category }.group { category.descricao }.group{valor}.group{descricao}.group{datavencimento}.select{valor.as(values)}.select{category.descricao.as(axis)}.select{descricao}.select{datavencimento.as(dateselected)}.order("axis").order("valor desc")
  end

  #TODO: Verificar a necessidade de implementar outro grafico (por causa do espaço não ficou legal)
  def despesas_por_status_report_table
    @dt = DateTime.now
    return Lancamento.despesas.por_status.este_mes(@dt).group { status_cd }.group{valor}.group{descricao}.group{datavencimento}
    .select { valor.as(values) }
    .select { "CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis" }.select{descricao}.select{datavencimento.as(dateselected)}.order("axis")
  end

  def despesas_por_centrodecusto_report_table
    @dt = DateTime.now
    return Lancamento.despesas.por_centrodecusto.este_mes(@dt).joins { centrodecusto }.group { centrodecusto.descricao }.group{valor}.group{descricao}.group{datavencimento}
    .select{valor.as(values)}.select{centrodecusto.descricao.as(axis)}.select{descricao}.select{datavencimento.as(dateselected)}.order("axis").order("valor desc")
  end

  def prazo_medio_pagamento_report
    @dt = DateTime.now
    return Lancamento.despesas.este_ano(@dt).quitados.por_mes.select{avg(dataacao-datavencimento).as(values)}.select { date_part('month', datavencimento).as(axis) }.order("axis")
  end

  #TODO: Ver com o butch se para este grafico o realizado funciona da mesma forma que no informativo de receita
  def ticket_medio_pagamento_report
    @dt = DateTime.now
    return Lancamento.receitas.este_ano(@dt).por_mes.select {avg(valor).as(values) }.select { date_part('month', datavencimento).as(axis) }
  end

  def aderencia_report
    @dt = DateTime.now
    @aderencia_report_part1 = Lancamento.receitas.este_ano(@dt).por_mes.select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }
    @aderencia_report_part2 = Lancamento.despesas.este_ano(@dt).por_mes.select { sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }

    @meta_series_part1 = Target.receitas.por_mes.este_ano(@dt).select{sum(valor).as(valor)}.select{date_part('month', data).as(mes) }
    @meta_series_part2 = Target.despesas.por_mes.este_ano(@dt).select{sum(valor).as(valor)}.select{date_part('month', data).as(mes) }

    @aderencia_report = "SELECT ((COALESCE(r.valor,0))/(CASE d.valor WHEN 0 THEN 1 ELSE COALESCE(d.valor,1) END)) as values, r.mes as axis
            FROM (#{@aderencia_report_part1.to_sql}) r
            FULL JOIN (#{@aderencia_report_part2.to_sql}) d ON r.mes = d.mes"
    @meta_report = "SELECT ((COALESCE(r.valor,0))/(CASE d.valor WHEN 0 THEN 1 ELSE COALESCE(d.valor,1) END)) as values, r.mes as axis
            FROM (#{@meta_series_part1.to_sql}) r
            FULL JOIN (#{@meta_series_part2.to_sql}) d ON r.mes = d.mes"

    return "SELECT a.values*100 as values, a.axis as axis, m.values*100 as meta
            FROM (#{@aderencia_report}) a
            INNER JOIN (#{@meta_report}) m ON a.axis = m.axis"
  end

  def ultimos_lancamentos_report
    return Lancamento.abertos.order("created_at desc").limit(Configurable.number_of_top_records).select{created_at}.select{valor}.select{datavencimento}.select{descricao}
  end

  def lancamentos_futuros_report
    @today = DateTime.now
    @dt = DateTime.now + (Configurable.number_of_future_days).days
    @lancamentos_futuros_part_1 = Lancamento.receitas.abertos.range(@today, @dt).por_mes.select{sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }
    @lancamentos_futuros_part_2 = Lancamento.despesas.abertos.range(@today, @dt).por_mes.select{sum(valor).as(valor) }.select { date_part('month', datavencimento).as(mes) }

    return "SELECT 5 as mes,0 as receitas,0 as despesas UNION  SELECT COALESCE(r.mes,d.mes) as mes, COALESCE(r.valor,0) as receitas, COALESCE(d.valor,0) as despesas
              FROM (#{@lancamentos_futuros_part_1.to_sql}) as r
              FULL JOIN (#{@lancamentos_futuros_part_2.to_sql}) as d ON r.mes = d.mes ORDER BY mes"
  end


end
