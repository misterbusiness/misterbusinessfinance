class ReportsController < ApplicationController
  include ApplicationHelper
  include LancamentosHelper

  def receita_realizada
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(receita_series_query(@dt))
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        #@json_rows = @json_rows + "'" + serie.mes + "'," + serie.valor.to_s + "],"
        @json_row = Array.new
        @json_row.push(Date::MONTHNAMES[serie.mes.to_f])
        @json_row.push(serie.valor.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'ColumnChart',
          :options => {
              #:chartArea => {},
              #:hAxis => {:showTextEvery => 30},
              #:legend => 'bottom',
          },
          :is3D => 'true',
          :title => 'Receita Realizada',
          :color => ['green'],
          :cols => [['string','mes'],['number','valor']],
          :rows => @json_rows
              #['B',344],['A',456]
         # :rows =>'['
         #     @report_series.each do |serie|
         #       [serie.mes, serie.valor],
         #     end

      }
    end
  end

  def despesa_realizada
  end

  def receita_por_categoria
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        #@json_rows = @json_rows + "'" + serie.mes + "'," + serie.valor.to_s + "],"
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'PieChart',
          :options => {
              #:chartArea => {},
              #:hAxis => {:showTextEvery => 30},
              #:legend => 'bottom',
          },
          :is3D => 'true',
          :title => 'Receita Realizada',
          :color => [],
          :cols => [['string','categoria'],['number','valores']],
          :rows => @json_rows
          #['B',344],['A',456]
          # :rows =>'['
          #     @report_series.each do |serie|
          #       [serie.mes, serie.valor],
          #     end

      }
    end
  end

  def despesa_por_categoria
  end

  def receita_por_status
    @dt = DateTime.now
    @report_series = Lancamento.find_by_sql(receita_por_status_series_query(@dt).to_sql)
    unless @report_series.nil?
      @json_rows = Array.new
      @report_series.each do |serie|
        #@json_rows = @json_rows + "'" + serie.mes + "'," + serie.valor.to_s + "],"
        @json_row = Array.new
        @json_row.push(serie.axis)
        @json_row.push(serie.values.to_f)
        @json_rows.push(@json_row)
      end

      render :json => {
          :type => 'PieChart',
          :options => {
              #:chartArea => {},
              #:hAxis => {:showTextEvery => 30},
              #:legend => 'bottom',
          },
          :is3D => 'true',
          :title => 'Receita Realizada',
          :color => [],
          :cols => [['string','status'],['number','valores']],
          :rows => @json_rows
          #['B',344],['A',456]
          # :rows =>'['
          #     @report_series.each do |serie|
          #       [serie.mes, serie.valor],
          #     end

      }
    end
  end

  def despesa_por_centrodecusto
  end
end

