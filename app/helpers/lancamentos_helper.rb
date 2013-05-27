module LancamentosHelper
  def caixa_series_query
    @caixa_series_part1 = Lancamento.receitas.quitados.por_mes.select{sum(valor).as(valor)}.select{date_part('month',datavencimento).as(mes)}
    @caixa_series_part2 = Lancamento.despesas.quitados.por_mes.select{sum(valor).as(valor)}.select{date_part('month',datavencimento).as(mes)}

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
end
