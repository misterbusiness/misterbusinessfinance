class ReportsController < ApplicationController
  include ApplicationHelper
  include LancamentosHelper

  # ************************************************************************************************************
  # Receitas actions
  # ************************************************************************************************************

  #@receita_series = Lancamento.find_by_sql(receita_series_query(@dt))
  #@despesa_series = Lancamento.find_by_sql(despesa_series_query(@dt))
  #@caixa_series = Lancamento.find_by_sql(caixa_series_query(@dt))

  def receita_estatisticas
    @dt = DateTime.now
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
              :colors => ['green','red','blue'],
              :title => 'Receita - Estatisticas',
              :width => '500',
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
              :width => '500',
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
              :colors => ['green','red','blue'],
              :title => 'Estatisticas - Caixa',
              :width => '500',
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
              :colors => ['green','red','blue'],
              :title => 'Receita Realizada',
              :width => '800',
              :seriesType => 'bars',
              :series => {1 => {:type => 'area', :pointSize => '6'}}
          },
          :cols => [['string', 'mes'], ['number', 'valor'], ['number','meta']],
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
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'ColumnChart',
          :options => {
              :colors => ['red'],
              :title => 'Despesa Realizada',
              :is3D => 'true',
              :enableInteractivity => 'true',
              :width => '800'
          },
          :cols => [['string', 'mes'], ['number', 'valor']],
          :rows => @json_rows
      }
    end
  end

  def receita_por_categoria
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt).to_sql)
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
    @dt = DateTime.now
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
    @report_series = Lancamento.find_by_sql(contas_a_receber_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
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
          :cols => [['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  #TODO: O grafico não está em escala de data

  def contas_a_receber_chart
    @report_series = Lancamento.find_by_sql(contas_a_receber_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
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
          :cols => [['string', 'data'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def recebimentos_atrasados_table
    @report_series = Lancamento.find_by_sql(recebimentos_atrasados_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
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
          :cols => [['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  #TODO: O grafico não está em escala de data

  def recebimentos_atrasados_chart
    @report_series = Lancamento.find_by_sql(recebimentos_atrasados_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
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
          :cols => [['string', 'data'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def top_receitas_table
    @report_series = Lancamento.find_by_sql(top_receitas_report_table.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
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
          :cols => [['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  #TODO: O grafico não está em escala de data

  def top_receitas_chart
    @report_series = Lancamento.find_by_sql(top_receitas_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Top receitas',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'data'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def receitas_por_categoria_table
    @report_series = Lancamento.find_by_sql(receitas_por_categoria_report_table.to_sql)
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
              :title => 'Receitas por categoria',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'categoria'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def receitas_por_categoria_chart
    @report_series = Lancamento.find_by_sql(receitas_por_categoria_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'LineChart',
          :options => {
              :title => 'Receitas por categoria',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'data'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def receitas_por_status_table
    @report_series = Lancamento.find_by_sql(receitas_por_status_report_table.to_sql)
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
              :is3D => 'true'
          },
          :cols => [['string', 'status'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def receitas_por_centrodecusto_table
    @report_series = Lancamento.find_by_sql(receitas_por_centrodecusto_report_table.to_sql)
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
              
              :width => '800'
          },
          :cols => [['string', 'CdC'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def prazo_medio_recebimento
    @report_series = Lancamento.find_by_sql(prazo_medio_recebimento_report.to_sql)
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
              :colors => ['green','red','blue'],
              :width => '800'
          },
          :cols => [['number', 'mes'], ['number', 'prazo']],
          :rows => @json_rows
      }
    end
  end

  def ticket_medio_vendas
    @report_series = Lancamento.find_by_sql(ticket_medio_vendas_report.to_sql)
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
    @report_series = Lancamento.find_by_sql(receitas_por_centrodecusto_report_table.to_sql)
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
        @json_row.push(serie.axis)
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
          :cols => [['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  #TODO: O grafico não está em escala de data
  def contas_a_pagar_chart
    @report_series = Lancamento.find_by_sql(contas_a_pagar_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Contas a pagar',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'data'], ['number', 'valores']],
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
        @json_row.push(serie.axis)
        @json_row.push(serie.descricao)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Contas vencidas',
              :is3D => 'true'
          },
          :cols => [['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  #TODO: O grafico não está em escala de data

  def contas_vencidas_chart
    @report_series = Lancamento.find_by_sql(contas_vencidas_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Contas vencidas',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'data'], ['number', 'valores']],
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
        @json_row.push(serie.axis)
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
          :cols => [['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def top_despesas_chart
    @report_series = Lancamento.find_by_sql(top_despesas_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Top despesas',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'data'], ['number', 'valores']],
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
        @json_row.push(serie.datavencimento)
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
          :cols => [['string', 'categoria'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
          :rows => @json_rows
      }
    end
  end

  def despesas_por_categoria_chart
    @report_series = Lancamento.find_by_sql(despesas_por_categoria_report_chart.to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Receitas por categoria',
              :is3D => 'true',
              :width => '800'
          },
          :cols => [['string', 'data'], ['number', 'valores']],
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
        @json_row.push(serie.datavencimento)
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
          :cols => [['string', 'status'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
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
        @json_row.push(serie.datavencimento)
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
          :cols => [['string', 'CdC'], ['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
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
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Receitas por status',
              :is3D => 'true',
              
              :width => '800'
          },
          :cols => [['string', 'mes'], ['number', 'prazo']],
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
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f*100)
        @json_rows.push(@json_row)
      end

      render :json => {
          :options => {
              :title => 'Aderencia',
              :is3D => 'true',
              
              :width => '800'
          },
          :cols => [['string', 'data'], ['number', 'valores']],
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
          :cols => [['string', 'criado'],['string', 'data'], ['string', 'descricao'], ['number', 'valores']],
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
                :colors => ['green','red'],
                :title => 'Lancamentos Futuros',
                :width => '800',
                :seriesType => 'bars',
                :series => {1 => {:type => 'bars'}
                }
            },
          :cols => [['number', 'mes'], ['number', 'receita'], ['number','despesa']],
          :rows => @json_rows
      }
    end
  end
end

