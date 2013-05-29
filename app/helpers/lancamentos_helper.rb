module LancamentosHelper
  def caixa_series_query(dt)
    @caixa_series_part1 = Lancamento.receitas.quitados.este_ano(@dt).por_mes.select{sum(valor).as(valor)}.select{date_part('month',datavencimento).as(mes)}
    @caixa_series_part2 = Lancamento.despesas.quitados.este_ano(@dt).por_mes.select{sum(valor).as(valor)}.select{date_part('month',datavencimento).as(mes)}

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

    return "SELECT valor, mes from ((#{@receita_series_part1.to_sql})
                    UNION (#{@receita_series_part2.to_sql})) as realizado order by mes"
  end

  def despesa_series_query (dt)
    @despesa_series_part1 = Lancamento.despesas.parcelamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    @despesa_series_part2 = Lancamento.despesas.lancamentos_realizados(dt)
    .select { sum(valor).as(valor) }
    .select { date_part('month', datavencimento).as(mes) }

    return "SELECT valor, mes from ((#{@despesa_series_part1.to_sql})
                  UNION (#{@despesa_series_part2.to_sql})) as realizado order by mes"

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
    return Lancamento.receitas.por_categoria.este_mes(dt).joins{category}.group{category.descricao}
        .select { sum(valor).as(values) }
        .select { category.descricao.as(axis) }
  end

  def receita_por_status_series_query(dt)
    return Lancamento.receitas.por_status.este_mes(dt).group{status_cd}
                .select { sum(valor).as(values) }
                .select {"CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis"}
  end


  def despesa_por_categoria_series_query(dt)
    return Lancamento.despesas.por_categoria.este_mes(dt).joins{category}.group{category.descricao}
    .select { sum(valor).as(values) }
    .select { category.descricao.as(axis) }
  end

  def despesa_por_centrodecusto_series_query(dt)
    return Lancamento.despesas.por_centrodecusto.este_mes(dt).joins{centrodecusto}.group{centrodecusto.descricao}
    .select { sum(valor).as(values) }
    .select { centrodecusto.descricao.as(axis) }
  end

  def despesa_por_status_series_query(dt)
    return Lancamento.despesas.por_status.este_mes(dt).group{status_cd}
    .select { sum(valor).as(values) }
    .select {"CASE WHEN status_cd=0 THEN 'aberto'
                                WHEN status_cd=1 THEN 'quitado'
                                WHEN status_cd=2 THEN 'estornado'
                                WHEN status_cd=3 THEN 'cancelado'
                            END AS axis"}
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
  # Receitas
  def contas_a_receber_series_query(dt_inicio)
    return Lancamento.abertos.receitas.a_partir_de(dt_inicio).por_mes
  end

  def recebimentos_atrasados_series_query(dt_inicio)
    return Lancamento.abertos.receitas.a_partir_de(dt_inicio).por_mes
  end

  def top_receitas_series_query
     return Lancamento.receitas
  end

end
