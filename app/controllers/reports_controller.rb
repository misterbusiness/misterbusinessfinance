class ReportsController < ApplicationController
  include ApplicationHelper
  include LancamentosHelper
  include ActionView::Helpers::NumberHelper

  def DateFormat(dateValue)
    return Time.parse(dateValue).utc.to_i*1000
  end


  # ************************************************************************************************************
  # Receitas actions
  # ************************************************************************************************************
  before_filter :load

  def load
    @dt_inicio = Time.now.beginning_of_month
    @dt_fim = Time.now.end_of_month

    if !params[:ts_begin].nil? and !params[:ts_end].nil? and !params[:ts_begin] == "undefined" and !params[:ts_end] == "undefined"
      @dt_inicio = Date.strptime(params[:ts_begin], "%d-%m-%Y")
      @dt_fim = Date.strptime(params[:ts_end], "%d-%m-%Y")

      @dt_inicio = Time.now.beginning_of_month unless @dt_fim >= @dt_inicio
      @dt_fim = Time.now.end_of_month unless @dt_fim >= @dt_inicio

    end
  end


  def receita_estatisticas
    @dt = @dt_inicio
    @report_series = Lancamento.find_by_sql(receita_series_query(@dt))
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(Date::MONTHNAMES[serie.mes.to_f])
        @json_row.push(serie.valor.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'ColumnChart',
          :options => {
              :colors => ['green', 'red', 'blue'],
              :title => 'Receita - Estatisticas',
              :width => '400',
              :height => '300'
          },
          :cols => [['string', 'mes'], ['number', 'valor']],
          :rows => @json_rows
      }
    end
  end

  def despesa_estatisticas
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(despesa_series_query(@dt))
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(Date::MONTHNAMES[serie.mes.to_f])
        @json_row.push(serie.valor.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'ColumnChart',
          :options => {
              :colors => ['red'],
              :title => 'Despesa Realizada',
              :is3D => 'true',
              :enableInteractivity => 'true',
              :width => '400',
              :height => '300'
          },
          :cols => [['string', 'mes'], ['number', 'valor']],
          :rows => @json_rows
      }
    end
  end


  def fluxo_caixa_estatisticas
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(caixa_series_query(@dt))
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(Date::MONTHNAMES[serie.mes.to_f])
        @json_row.push(serie.valor.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :colors => ['green', 'red', 'blue'],
              :title => 'Estatisticas - Caixa',
              :width => '400',
              :height => '300'
          },
          :cols => [['string', 'mes'], ['number', 'valor']],
          :rows => @json_rows
      }
    end
  end

  def receita_realizada
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(receita_series_query(@dt))
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(Date::MONTHNAMES[serie.mes.to_f])
        @json_row.push(serie.valor.to_f)
        @json_row.push(serie.meta.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'ColumnChart',
          :options => {
              :colors => ['green', 'red', 'blue'],
              :title => 'Receita Realizada',
              :width => '800',
              :seriesType => 'bars',
              :series => {1 => {:type => 'area', :pointSize => '6'}}
          },
          :cols => [['string', 'mes'], ['number', 'valor'], ['number', 'meta']],
          :rows => @json_rows
      }
    end
  end

  def despesa_realizada
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(despesa_series_query(@dt))
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(Date::MONTHNAMES[serie.mes.to_f])
        @json_row.push(serie.valor.to_f)
        @json_row.push(serie.meta.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'ColumnChart',
          :options => {
              :colors => ['red', 'blue'],
              :title => 'Despesa Realizada',
              :is3D => 'true',
              :enableInteractivity => 'true',
              :width => '800',
              :seriesType => 'bars',
              :series => {1 => {:type => 'area', :pointSize => '6'}}
          },
          :cols => [['string', 'mes'], ['number', 'valor'], ['number', 'meta']],
          :rows => @json_rows
      }
    end
  end


  # ******************************************************************************************************************************

  # FLUXO DE CAIXA

  # ******************************************************************************************************************************
  def fluxo_de_caixa
    @referencia = params[:ano_referencia].to_i

    if @referencia == 0 or !@referencia.is_a? Integer
      @referencia = DateTime.now.year
    end

    @dt = DateTime.new(@referencia,1,1)

    @inicio = @dt.beginning_of_year
    @fim = @dt.end_of_year

    @inicio_anterior = @inicio - 1.year
    @fim_anterior = @fim - 1.year

    # Busca de dados

    # Saldo inicial

    @total_receitas_inicial_realizado = Lancamento.receitas.quitados.acao_ate(@inicio).sum(:valor)
    @total_despesas_inicial_realizado = Lancamento.despesas.quitados.acao_ate(@inicio).sum(:valor)
    @saldo_inicial_realizado = @total_receitas_inicial_realizado - @total_despesas_inicial_realizado

    @total_receitas_inicial_projetado = Lancamento.receitas.validos.ate(@inicio).sum(:valor)
    @total_despesas_inicial_projetado = Lancamento.despesas.validos.ate(@inicio).sum(:valor)
    @saldo_inicial_projetado = @total_receitas_inicial_projetado - @total_despesas_inicial_projetado

    # Receitas realizadas

    @receitas_realizadas_vendas = (Lancamento.find_by_sql(fluxo_caixa_receitas_vendas_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @receitas_realizadas_financeiras = (Lancamento.find_by_sql(fluxo_caixa_receitas_financeiras_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @receitas_realizadas_outros = (Lancamento.find_by_sql (fluxo_caixa_receitas_outros_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    # Receitas projetadas

    @receitas_projetadas_vendas = (Lancamento.find_by_sql(fluxo_caixa_receitas_vendas_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @receitas_projetadas_financeiras = (Lancamento.find_by_sql(fluxo_caixa_receitas_financeiras_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @receitas_projetadas_outros = (Lancamento.find_by_sql (fluxo_caixa_receitas_outros_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    # Despesas realizadas

    @despesas_realizadas_adminstrativas = (Lancamento.find_by_sql(fluxo_caixa_despesas_administrativas_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_realizadas_producao = (Lancamento.find_by_sql(fluxo_caixa_despesas_producao_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_realizadas_financeiras = (Lancamento.find_by_sql(fluxo_caixa_despesas_financeiras_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_realizadas_investimentos = (Lancamento.find_by_sql(fluxo_caixa_despesas_investimentos_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_realizadas_outras = (Lancamento.find_by_sql(fluxo_caixa_despesas_outros_realizado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    # Despesas projetadas

    @despesas_projetadas_adminstrativas = (Lancamento.find_by_sql(fluxo_caixa_despesas_administrativas_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_projetadas_producao = (Lancamento.find_by_sql(fluxo_caixa_despesas_producao_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_projetadas_financeiras = (Lancamento.find_by_sql(fluxo_caixa_despesas_financeiras_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_projetadas_investimentos = (Lancamento.find_by_sql(fluxo_caixa_despesas_investimentos_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_projetadas_outras = (Lancamento.find_by_sql(fluxo_caixa_despesas_outros_projetado(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    # Constroi as estruturas de dados

    @receitas_realizadas_soma = Hash.new
    @receitas_projetadas_soma = Hash.new
    @despesas_realizadas_soma = Hash.new
    @despesas_projetadas_soma = Hash.new
    @geracao_caixa_realizada = Hash.new
    @geracao_caixa_projetada = Hash.new
    @saldo_fechamento_realizado = Hash.new
    @saldo_abertura_realizado = Hash.new
    @saldo_fechamento_projetado = Hash.new
    @saldo_abertura_projetado = Hash.new

    (1..12).each do |mes|
      @receitas_realizadas_soma[mes] = @receitas_realizadas_vendas[mes] + @receitas_realizadas_financeiras[mes] + @receitas_realizadas_outros[mes]
      @receitas_projetadas_soma[mes] = @receitas_projetadas_vendas[mes] + @receitas_projetadas_financeiras[mes] + @receitas_projetadas_outros[mes]
      @despesas_realizadas_soma[mes] = @despesas_realizadas_adminstrativas[mes] + @despesas_realizadas_financeiras[mes] + @despesas_realizadas_investimentos[mes] + @despesas_realizadas_producao[mes] + @despesas_realizadas_outras[mes]
      @despesas_projetadas_soma[mes] = @despesas_projetadas_adminstrativas[mes] + @despesas_projetadas_financeiras[mes] + @despesas_projetadas_investimentos[mes] + @despesas_projetadas_producao[mes] + @despesas_projetadas_outras[mes]
      @geracao_caixa_realizada[mes] = @receitas_realizadas_soma[mes] - @despesas_realizadas_soma[mes]
      @geracao_caixa_projetada[mes] = @receitas_projetadas_soma[mes] - @despesas_projetadas_soma[mes]

      if mes == 1
        @saldo_abertura_realizado[mes] = @saldo_inicial_realizado
      else
        @saldo_abertura_realizado[mes] = @saldo_fechamento_realizado[(mes-1)]
      end

      if mes == 1
        @saldo_fechamento_realizado[mes] = @saldo_inicial_realizado + @geracao_caixa_realizada[mes]
      else
        @saldo_fechamento_realizado[mes] = @saldo_abertura_realizado[(mes-1)] + @geracao_caixa_realizada[mes]
      end

      if mes == 1
        @saldo_abertura_projetado[mes] = @saldo_inicial_projetado
      else
        @saldo_abertura_projetado[mes] = @saldo_fechamento_projetado[(mes-1)]
      end

      if mes == 1
        @saldo_fechamento_projetado[mes] = @saldo_inicial_projetado + @geracao_caixa_projetada[mes]
      else
        @saldo_fechamento_projetado[mes] = @saldo_abertura_projetado[(mes-1)] + @geracao_caixa_projetada[mes]
      end
    end
  end

  def resultados
    @referencia = params[:ano_referencia].to_i

    if @referencia == 0 or !@referencia.is_a? Integer
      @referencia = DateTime.now.year
    end

    @dt = DateTime.new(@referencia,1,1)

    @inicio = @dt.beginning_of_year
    @fim = @dt.end_of_year

    @inicio_anterior = @inicio - 1.year
    @fim_anterior = @fim - 1.year


    @receitas_operacionais_vendas = (Lancamento.find_by_sql(resultados_receitas_vendas(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @receitas_operacionais_outros = (Lancamento.find_by_sql(resultados_receitas_outros(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    @receitas_operacionais = Hash.new
    (1..12).each do |mes|
      @receitas_operacionais[mes] = @receitas_operacionais_vendas[mes] + @receitas_operacionais_outros[mes]
    end

    @despesas_produtos_vendidos = (Lancamento.find_by_sql(resultados_despesas_producao(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @lucro_bruto = Hash.new
    (1..12).each do |mes|
      @lucro_bruto[mes] = @receitas_operacionais[mes] - @despesas_produtos_vendidos[mes]
    end

    @despesas_administrativas = (Lancamento.find_by_sql(resultados_despesas_administrativas(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}
    @despesas_comerciais = (Lancamento.find_by_sql(resultados_despesas_vendas(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    @despesas_administrativas_comerciais = Hash.new
    (1..12).each do |mes|
      @despesas_administrativas_comerciais[mes] = @despesas_administrativas[mes] + @despesas_comerciais[mes]
    end

    @lucro_operacional = Hash.new
    (1..12).each do |mes|
      @lucro_operacional[mes] = @lucro_bruto[mes] - (@despesas_administrativas[mes] + @despesas_comerciais[mes])
    end

    @receitas_financeiras = (Lancamento.find_by_sql(resultados_receitas_financeiras(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    @despesas_financeiras = (Lancamento.find_by_sql(resultados_despesas_financeiras(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    @despesas_impostos = (Lancamento.find_by_sql(resultados_despesas_impostos(@inicio,@fim))).inject({}){|h,item| h[item.mes.to_i] = item.value.to_f; h}

    @lucro_liquido = Hash.new
    (1..12).each do |mes|
      @lucro_liquido[mes] = @lucro_operacional[mes] + @receitas_financeiras[mes]
    end

    @margem_operacional = Hash.new
    (1..12).each do |mes|
      @margem_operacional[mes] = @receitas_operacionais[mes]==0 ? 0 : @lucro_operacional[mes]/@receitas_operacionais[mes]*100
    end

    @margem_liquida = Hash.new
    (1..12).each do |mes|
      @margem_liquida[mes] = @receitas_operacionais[mes]==0 ? 0 : @lucro_liquido[mes]/@receitas_operacionais[mes]*100
    end
  end

  def indicadores

  end


#def fluxo_de_caixa
  #  @dt = DateTime.now
  #
  #  @inicio = @dt.beginning_of_year
  #  @fim = @dt.end_of_year
  #
  #  @inicio_anterior = @inicio - 1.year
  #  @fim_anterior = @fim - 1.year
  #
  #
  #  # Busca pela serie de lançamentos no formato: mes categoria projetado realizado
  #  @report_receitas_series = Lancamento.find_by_sql(fluxo_caixa_receitas_report(@inicio, @fim))
  #
  #  # Calcula o total de receitas
  #  # Realizado
  #  @total_receitas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @report_receitas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_receitas[mes].realizado = sum + subitem.realizado.to_i
  #  end}
  #  #Projetado
  #  @report_receitas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_receitas[mes].projetado = sum + subitem.projetado.to_i
  #  end}
  #
  #  # Agrupa os lançamentos de fluxo de caixa de acordo com a categoria
  #  @general_receitas = @report_receitas_series.group_by(&:descricao).to_hash
  #
  #  @total_receitas_inicial = Lancamento.receitas.quitados.acao_ate(@inicio).sum(:valor)
  #  @total_despesas_inicial = Lancamento.despesas.quitados.acao_ate(@inicio).sum(:valor)
  #
  #  # Calcula o total do ano anterior
  #  #@total_despesas_anterior = Lancamento.despesas.quitados.acao_range(@inicio_anterior, @fim_anterior).sum(:valor)
  #  #@total_receitas_anterior = Lancamento.receitas.quitados.acao_range(@inicio_anterior, @fim_anterior).sum(:valor)
  #  @saldo_inicial = @total_receitas_inicial - @total_despesas_inicial
  #
  #  @total_projetado_receitas_inicial = Lancamento.receitas.validos.ate(@inicio).sum(:valor)
  #  @total_projetado_despesas_inicial = Lancamento.despesas.validos.ate(@inicio).sum(:valor)
  #  @saldo_projetado_inicial = @total_projetado_receitas_inicial - @total_projetado_despesas_inicial
  #
  #  # Calcula o acumulado de receitas
  #  # Realizado
  #  @acumulado_receitas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @total_receitas.inject(@total_receitas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.realizado
  #    @acumulado_receitas[mes].realizado = sum
  #  end
  #  #Projetado
  #  @total_receitas.inject(@total_projetado_receitas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.projetado
  #    @acumulado_receitas[mes].projetado = sum
  #  end
  #
  #  # Busca pela serie de lançamentos no formato: mes categoria projetado realizado
  #  @report_despesas_series = Lancamento.find_by_sql(fluxo_caixa_despesas_report(@inicio, @fim))
  #
  #  # Calcula o total de despesas
  #  # Realizado
  #  @total_despesas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @report_despesas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_despesas[mes].realizado = sum + subitem.realizado.to_i
  #  end}
  #  #Projetado
  #  @report_despesas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_despesas[mes].projetado = sum + subitem.projetado.to_f
  #  end}
  #  # Agrupa os lançamentos de fluxo de caixa de acordo com a categoria
  #  @general_despesas = @report_despesas_series.group_by(&:descricao).to_hash
  #
  #  # Calcula o acumulado de despesas
  #  # Realizado
  #  @acumulado_despesas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @total_despesas.inject(@total_despesas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.realizado
  #    @acumulado_despesas[mes].realizado = sum
  #  end
  #  # Projetado
  #  @total_despesas.inject(@total_projetado_despesas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.projetado
  #    @acumulado_despesas[mes].projetado = sum
  #  end
  #
  #
  #  render :layout => nil
  #end
  #
  #def resultados
  #  @dt = DateTime.now
  #
  #  @inicio = @dt.beginning_of_year
  #  @fim = @dt.end_of_year
  #
  #  @inicio_anterior = @inicio - 1.year
  #  @fim_anterior = @fim - 1.year
  #
  #
  #
  #
  #
  #  # Busca pela serie de lançamentos no formato: mes categoria projetado realizado
  #  @report_receitas_series = Lancamento.find_by_sql(fluxo_caixa_receitas_report(@inicio, @fim))
  #
  #  # Calcula o total de receitas
  #  # Realizado
  #  @total_receitas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @report_receitas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_receitas[mes].realizado = sum + subitem.realizado.to_f
  #  end}
  #  #Projetado
  #  @report_receitas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_receitas[mes].projetado = sum + subitem.projetado.to_f
  #  end}
  #
  #  # Agrupa os lançamentos de fluxo de caixa de acordo com a categoria
  #  @general_receitas = @report_receitas_series.group_by(&:descricao).to_hash
  #
  #  @total_receitas_inicial = Lancamento.receitas.quitados.acao_ate(@inicio).sum(:valor)
  #  @total_despesas_inicial = Lancamento.despesas.quitados.acao_ate(@inicio).sum(:valor)
  #
  #  # Calcula o total do ano anterior
  #  #@total_despesas_anterior = Lancamento.despesas.quitados.acao_range(@inicio_anterior, @fim_anterior).sum(:valor)
  #  #@total_receitas_anterior = Lancamento.receitas.quitados.acao_range(@inicio_anterior, @fim_anterior).sum(:valor)
  #  @saldo_inicial = @total_receitas_inicial - @total_despesas_inicial
  #
  #  @total_projetado_receitas_inicial = Lancamento.receitas.validos.ate(@inicio).sum(:valor)
  #  @total_projetado_despesas_inicial = Lancamento.despesas.validos.ate(@inicio).sum(:valor)
  #  @saldo_projetado_inicial = @total_projetado_receitas_inicial - @total_projetado_despesas_inicial
  #
  #  # Calcula o acumulado de receitas
  #  # Realizado
  #  @acumulado_receitas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @total_receitas.inject(@total_receitas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.realizado
  #    @acumulado_receitas[mes].realizado = sum
  #  end
  #  #Projetado
  #  @total_receitas.inject(@total_projetado_receitas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.projetado
  #    @acumulado_receitas[mes].projetado = sum
  #  end
  #
  #  # Busca pela serie de lançamentos no formato: mes categoria projetado realizado
  #  @report_despesas_series = Lancamento.find_by_sql(fluxo_caixa_despesas_report(@inicio, @fim))
  #
  #  # Calcula o total de despesas
  #  # Realizado
  #  @total_despesas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @report_despesas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_despesas[mes].realizado = sum + subitem.realizado.to_f
  #  end}
  #  #Projetado
  #  @report_despesas_series.group_by(&:mes).map {|mes,item| item.inject(0) do |sum, subitem|
  #    @total_despesas[mes].projetado = sum + subitem.projetado.to_f
  #  end}
  #  # Agrupa os lançamentos de fluxo de caixa de acordo com a categoria
  #  @general_despesas = @report_despesas_series.group_by(&:descricao).to_hash
  #
  #  # Calcula o acumulado de despesas
  #  # Realizado
  #  @acumulado_despesas = Hash.new { |hash, key| hash[key] = CaixaMes.new }
  #  @total_despesas.inject(@total_despesas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.realizado
  #    @acumulado_despesas[mes].realizado = sum
  #  end
  #  # Projetado
  #  @total_despesas.inject(@total_projetado_despesas_inicial) do |sum, (mes,item)|
  #    sum = sum + item.projetado
  #    @acumulado_despesas[mes].projetado = sum
  #  end
  #
  #
  #  render :layout => nil
  #end



  def receita_por_categoria
    @dt = @dt_inicio
    @report_series = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt))
    #@report_series = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'PieChart',
          :options => {
              :title => 'Receita por categoria',
              :is3D => 'true',
              :enableInteractivity => 'true',
              :width => '500'
          },
          :cols => [['string', 'categoria'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  # Código para o treemap
  #def receita_por_categoria
  #    @dt = @dt_inicio
  #    @report_series = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt))
  #    #@report_series = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt_inicio, @dt_fim).to_sql)
  #    unless @report_series.nil?
  #      @json_rows = Array.new
  #      @json_row = Array.new
  #      # Categoria root
  #      @json_row.push("Categorias")
  #      @json_row.push(nil)
  #      @json_row.push(0)
  #      @json_rows.push(@json_row)
  #
  #      @report_series.each do |serie|
  #        @json_row = Array.new
  #        @json_row.push(serie.axis)
  #        #@formatted_value = "{v: '#{serie.axis}', f: '#{serie.values.to_s}'}"
  #        #@json_row.push(@formatted_value)
  #        @category = Category.find(serie.cat_id)
  #        if @category.parent.nil?
  #          @json_row.push("Categorias")
  #        else
  #          @json_row.push(@category.parent.descricao)
  #        end
  #        @json_row.push(serie.values.to_f)
  #        @json_rows.push(@json_row)
  #      end
  #
  #      render :json => {
  #          :type => 'PieChart',
  #          :options => {
  #              :title => 'Receita por categoria',
  #              :is3D => 'true',
  #              :enableInteractivity => 'true',
  #              :width => '500',
  #              :minColor => '#f00',
  #              :hintOpacity => '0.7',
  #              :midColor =>  '#ddd',
  #              :maxColor =>  '#0d0',
  #              :headerHeight =>  15,
  #              :fontColor =>  'black',
  #              :showScale =>  true,
  #              :showTooltips =>  true,
  #              :useWeightedAverageForAggregation => true
  #          },
  #
  #          :cols => [['string', 'categoria'],['string', 'parent'], ['number', 'valores']],
  #          :rows => @json_rows
  #      }
  #    end
  #end


  def despesa_por_categoria
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(despesa_por_categoria_series_query(@dt).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'PieChart',
          :options => {
              :title => 'Despesa por categoria',
              :is3D => 'true',
              :enableInteractivity => 'true',
              :width => '500'
          },
          :cols => [['string', 'categoria'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def receita_por_status
    @dt = @dt_inicio
    @report_series = Lancamento.find_by_sql(receita_por_status_series_query(@dt).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'PieChart',
          :options => {
              :title => 'Receita por status',
              :is3D => 'true',
              :enableInteractivity => 'true',
              :width => '500'
          },
          :cols => [['string', 'status'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def despesa_por_centrodecusto
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(despesa_por_centrodecusto_series_query(@dt).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'PieChart',
          :options => {
              :title => 'Despesa por centro de custo',
              :is3D => 'true',
              :width => '500'
          },
          :cols => [['string', 'centro de custo'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  #TODO: ver como a tabela fica com descrições grandes
  def contas_a_receber_table
    #@report_series = Lancamento.find_by_sql(contas_a_receber_report_table.to_sql)
    @report_series = Lancamento.find_by_sql(contas_a_receber_report_table(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(DateFormat(serie.axis))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Contas a receber',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          # :cols => [['number', 'data'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end


  def recebimentos_atrasados_table
    #@report_series = Lancamento.find_by_sql(recebimentos_atrasados_report_table.to_sql)
    @report_series = Lancamento.find_by_sql(recebimentos_atrasados_report_table(@dt_inicio,@dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(DateFormat(serie.axis))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Contas a receber',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end


  def top_receitas_table
    #@report_series = Lancamento.find_by_sql(top_receitas_report_table.to_sql)
    @report_series = Lancamento.find_by_sql(top_receitas_report_table(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(DateFormat(serie.axis))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Top receitas',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end


  def receitas_por_categoria_table
    #@dt = @dt_inicio
    #@report_series = Lancamento.find_by_sql(receitas_por_categoria_report_table(@dt).to_sql)
    @report_series = Lancamento.find_by_sql(receitas_por_categoria_report_table(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(DateFormat(serie.dateselected))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'AreaChart',
          :options => {
              :title => 'Receitas por categoria',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'categoria'], ['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end


  def receitas_por_status_table
    @report_series = Lancamento.find_by_sql(receitas_por_status_report_table(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(DateFormat(serie.dateselected))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Receitas por status',
              :is3D => 'true'
          },
          :cols => [['string', 'status'], ['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def receitas_por_centrodecusto_table
    @report_series = Lancamento.find_by_sql(receitas_por_centrodecusto_report_table(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(DateFormat(serie.dateselected))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Receitas por status',
              :is3D => 'true',

              :width => '800'
          },
          :cols => [['string', 'CdC'], ['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def prazo_medio_recebimento
    @report_series = Lancamento.find_by_sql(prazo_medio_recebimento_report(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis.to_f)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Receitas por status',
              :is3D => 'true',
              :colors => ['green', 'red', 'blue'],
              :width => '800'
          },
          :cols => [['number', 'mes'], ['number', 'prazo']],
          :rows => @json_rows
      }
    end
  end

  def ticket_medio_vendas
    #@report_series = Lancamento.find_by_sql(ticket_medio_vendas_report(@dt_inicio, @dt_fim).to_sql)
    @sql = ticket_medio_vendas_report(@dt_inicio, @dt_fim).to_sql
    @report_series = Lancamento.find_by_sql(ticket_medio_vendas_report(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis.to_f)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Ticket Medio Vendas',
              :is3D => 'true'
          },
          :cols => [['number', 'mes'], ['number', 'valor']],
          :rows => @json_rows
      }
    end
  end


  def prazo_medio_recebimento_table
    @report_series = Lancamento.find_by_sql(receitas_por_centrodecusto_report_table(@dt_inicio, @dt_fim).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.datavencimento)
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Receitas por status',
              :is3D => 'true',
              :allowHtml => 'true'
          },
          :cols => [['string', 'CdC'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  # ************************************************************************************************************
  # Despesas actions
  # ************************************************************************************************************
  def contas_a_pagar_table
    @report_series = Lancamento.find_by_sql(contas_a_pagar_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(DateFormat(serie.axis))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Contas a pagar',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def contas_vencidas_table
    @report_series = Lancamento.find_by_sql(contas_vencidas_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(DateFormat(serie.axis))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Contas vencidas',
              :is3D => 'true'
          },
          :cols => [['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def top_despesas_table
    @report_series = Lancamento.find_by_sql(top_despesas_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(DateFormat(serie.axis))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Top despesas',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def despesas_por_categoria_table
    @report_series = Lancamento.find_by_sql(despesas_por_categoria_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(DateFormat(serie.dateselected))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Despesas por categoria',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'categoria'], ['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def despesas_por_status_table
    @report_series = Lancamento.find_by_sql(despesas_por_status_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(DateFormat(serie.dateselected))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Despesas por status',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'status'], ['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def despesas_por_centrodecusto_table
    @report_series = Lancamento.find_by_sql(despesas_por_centrodecusto_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(DateFormat(serie.dateselected))
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Despesas por centro de custo',
              :is3D => 'true',

              :width => '800'
          },
          :cols => [['string', 'CdC'], ['date', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def prazo_medio_pagamento
    @report_series = Lancamento.find_by_sql(prazo_medio_pagamento_report.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis.to_f)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Receitas por status',
              :is3D => 'true',

              :width => '800'
          },
          :cols => [['number', 'mes'], ['number', 'prazo']],
          :rows => @json_rows
      }
    end
  end

  def aderencia
    @report_series = Lancamento.find_by_sql(aderencia_report)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis.to_f)
        @json_row.push(serie.values.to_f)
        @json_row.push(serie.meta.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Aderencia',
              :colors => ['blue', 'black'],
              :is3D => 'true',
              :width => '800',
              :seriesType => 'bars',
              :series => {1 => {:type => 'area', :pointSize => '6'}}
          },
          :cols => [['number', 'mes'], ['number', 'valor'], ['number', 'meta']],
          :rows => @json_rows
      }
    end
  end

  def ultimos_lancamentos
    @report_series = Lancamento.find_by_sql(ultimos_lancamentos_report)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.created_at)
        @json_row.push(serie.datavencimento)
        @json_row.push(serie.descricao)
        @json_row.push(serie.valor.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Ultimos Lancamentos',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'criado'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def categories_lista
    @report_series = Category.select(:descricao)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.descricao)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Lista de categorias',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'categoria']],
          :rows => @json_rows
      }
    end
  end

  def centrodecustos_lista
    @report_series = Centrodecusto.select(:descricao)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.descricao)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Lista de centros de custo',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'centro de custo']],
          :rows => @json_rows
      }
    end
  end

  def lancamentos_futuros
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(lancamentos_futuros_report)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.mes.to_f)
        @json_row.push(serie.receitas.to_f)
        @json_row.push(serie.despesas.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'ComboChart',
          :options => {
              :colors => ['green', 'red'],
              :title => 'Lancamentos Futuros',
              :width => '800',
              :seriesType => 'bars',
              :series => {1 => {:type => 'bars'}
              }
          },
          :cols => [['number', 'mes'], ['number', 'receita'], ['number', 'despesa']],
          :rows => @json_rows
      }
    end
  end
end

