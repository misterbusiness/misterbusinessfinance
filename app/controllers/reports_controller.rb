class ReportsController < ApplicationController
  include ApplicationHelper
  include LancamentosHelper

  def receita_realizada
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
              :colors => ['green'],
              :title => 'Receita Realizada',
              :is3D => 'true'
            },
          :cols => [['string','mes'],['number','valor']],
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
              :is3D => 'true'
          },
          :cols => [['string','mes'],['number','valor']],
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
              :is3D => 'true'
          },
          :cols => [['string','categoria'],['number','valores']],
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
              :is3D => 'true'
          },
          :cols => [['string','categoria'],['number','valores']],
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
              :is3D => 'true'
          },
          :cols => [['string','status'],['number','valores']],
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
              :is3D => 'true'
          },
          :cols => [['string','centro de custo'],['number','valores']],
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
              :is3D => 'true'
          },
          :cols => [['string','data'],['string','descricao'],['number','valores']],
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
              :is3D => 'true'
          },
          :cols => [['string','data'],['number','valores']],
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
              :is3D => 'true'
          },
          :cols => [['string','data'],['string','descricao'],['number','valores']],
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
              :is3D => 'true'
          },
          :cols => [['string','data'],['number','valores']],
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
          :type => 'LineChart',
          :options => {
              :title => 'Contas a receber',
              :is3D => 'true'
          },
          :cols => [['string','data'],['string','descricao'],['number','valores']],
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
              :title => 'Contas a receber',
              :is3D => 'true'
          },
          :cols => [['string','data'],['number','valores']],
          :rows => @json_rows
      }
    end
  end


end

