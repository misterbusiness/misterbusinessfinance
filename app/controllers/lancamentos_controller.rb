#!/bin/env ruby
# encoding: utf-8
require 'roo'
#require 'iconv'

class LancamentosController < ApplicationController
  include ApplicationHelper
  include LancamentosHelper
  include ActionView::Helpers::NumberHelper

  before_filter :load

  # GET /lancamentos/filter
  # GET /lancamentos/filter.json

  #default params


  # Testando a funcionalidade de levar apenas os dados para o cliente
  def filter_no_server

    # Build Query functionality
    query = Lancamento.unscoped

    #query = Lancamento.padrao
    query = query.scoped_by_centrodecusto_id(params[:centrodecusto]) unless  params[:centrodecusto].nil?
    query = query.scoped_by_category_id(params[:categoria]) unless  params[:categoria].nil?
    query = query.scoped_by_status_cd(params[:status]) unless params[:status].nil?

    query = query.por_descricao('%' + params[:filtro_descricao] + '%') unless params[:filtro_descricao].blank?
    query = query.a_partir_de(params[:filtro_vencimento_ini]) unless params[:filtro_vencimento_ini].blank?
    query = query.ate(params[:filtro_vencimento_final]) unless params[:filtro_vencimento_final].blank?

    #query = query.por_descricao('%' + params[:descricao] + '%') unless params[:descricao].nil?
    #query = query.ate(params[:datavencimentoate]) unless params[:datavencimentoate].nil?
    #query = query.a_partir_de(params[:datavencimentode]) unless params[:datavencimentode].nil?

    if (params[:receita] == 'S' and params[:despesa] == 'N')
      query = query.receitas

    elsif (params[:receita] == 'N' and params[:despesa] == 'S')
      query = query.despesas

    end

    if not params[:valor].nil? then
      case params[:seletorvalor]
        when "="
          query = query.valor_igual(params[:valor])
        when "<"
          query = query.valor_menor(params[:valor])
        when ">"
          query = query.valor_maior(params[:valor])
      end

    end

    @lancamentos = query


    # Teste retorno json
    json_rows = Array.new
    @lancamentos.each do |serie|
      json_row = Array.new
      json_row.push("<a href='#{estornar_lancamento_path(serie.id)}' class='btn'>E</a>")
      json_row.push("<a href='#{quitar_lancamento_path(serie.id)}' class='btn'>Q</a>")
      json_row.push(serie.descricao)
      json_row.push(serie.datavencimento)
      json_row.push(serie.dataacao)
      json_row.push(serie.valor.to_f)
      json_row.push(serie.category.descricao)
      json_row.push(serie.centrodecusto.descricao)
      json_row.push(serie.status)
      json_rows.push(json_row)
    end

    render :json => {
        :aaData => json_rows
    }
  end


  # Testando a funcionalidade de processamento completo pelo servidor
  def filter

    if params[:filtro_command] == "default_filter"
      @lancamento = Lancamento.padrao.paginate(:page => 1, :per_page => 10)
    else

      # Params collect default
      per_page = 10
      curr_page = 1
      start_of_page = 0
      columns = {"2" => "descricao", "3" => "datavencimento",
                 "4" => "dataacao", "5" => "valor", "6" => "category_id",
                 "7" => "centrodecusto_id", "8" => "status_cd"}
      sort_col = "datavencimento"
      sort_direction = "asc"

      # Build Query functionality
      query = Lancamento.unscoped

      query = query.scoped_by_centrodecusto_id(params[:filtro_centrodecusto]) unless  params[:filtro_centrodecusto].blank?
      query = query.scoped_by_category_id(params[:filtro_categoria]) unless  params[:filtro_categoria].blank?
      query = query.scoped_by_status_cd(params[:filtro_status]) unless params[:filtro_status].blank?

      query = query.por_descricao('%' + params[:filtro_descricao] + '%') unless params[:filtro_descricao].blank?
      query = query.a_partir_de(params[:filtro_vencimento_ini]) unless params[:filtro_vencimento_ini].blank?
      query = query.ate(params[:filtro_vencimento_final]) unless params[:filtro_vencimento_final].blank?


      if (params[:filtro_receita] == 'S' and params[:filtro_despesa] == 'N')
        query = query.receitas

      elsif (params[:filtro_receita] == 'N' and params[:filtro_despesa] == 'S')
        query = query.despesas
      end

      # Se não estiver na sintaxe correta, não faz nada
      begin
        if !params[:filtro_valor].blank?

          valor_split = params[:filtro_valor].split(" ")
          operator = valor_split[0]
          valor1 = valor_split[1].to_f
          valor2 = valor_split[2].to_f unless valor_split.count < 2


          case operator
            when "="
              query = query.valor_igual(valor1)
            when "<"
              query = query.valor_menor(valor1)
            when ">"
              query = query.valor_maior(valor1)
            when ">="
              query = query.valor_menor_igual(valor1)
            when "<="
              query = query.valor_maior_igual(valor1)
            when "["
              query = query.valor_entre(valor1,valor2)
          end

        end
      rescue
        #Do nothing
      end

      number_of_records = query.count
      start_of_page = params[:iDisplayStart] unless params[:iDisplayStart].nil?

      # Fixed to accept datatable params
      per_page = params[:iDisplayLength] unless params[:iDisplayLength].nil?
      curr_page = ((start_of_page.to_f+1) / per_page.to_f).ceil unless per_page == "0"
      sort_col = columns[params[:iSortCol_0]] unless params[:iSortCol_0].nil?
      sort_direction = params[:sSortDir_0] unless params[:sSortDir_0].nil?

      query = query.order("#{sort_col} #{sort_direction}")
      @lancamentos = query.paginate(:page => curr_page, :per_page => per_page)

      #major_total = query.sum('valor')
      major_total = query.inject(0) {|sum, lancamento| lancamento.receita? ? sum + lancamento.valor : sum - lancamento.valor}
      major_total = number_to_currency(major_total, precision: 2, unit: "R$ ")

    end
    # Teste retorno json
    json_rows = Array.new
    @lancamentos.each do |serie|
      json_row = Array.new
      json_row.push("<a href='#{estornar_lancamento_path(serie.id)}' class='btn mister-table-button asd' data-remote='true'>E</a>")
      json_row.push("<a href='#{quitar_lancamento_path(serie.id)}' class='btn mister-table-button' data-remote='true'>Q</a>")
      json_row.push(serie.descricao)
      json_row.push(!serie.datavencimento.nil? ? serie.datavencimento.strftime('%d-%m-%Y') : nil)
      json_row.push(!serie.dataacao.nil? ? serie.dataacao.strftime('%d-%m-%Y') : nil)
      serie.receita? ? sinal = "+" : sinal = "-"
      json_row.push(number_to_currency(("#{sinal}#{serie.valor}").to_f, precision: 2, unit: "R$ "))
      json_row.push(serie.category.descricao)
      json_row.push(serie.centrodecusto.descricao)
      json_row.push(serie.status)
      json_rows.push(json_row)
    end


    render :json => {
        :sEcho => params[:sEcho],
        :iTotalRecords => number_of_records,
        :iTotalDisplayRecords => number_of_records,
        :majorTotal => major_total,
        :aaData => json_rows
    }

    #render :layout => nil
  end

  def load
    @lancamento = Lancamento.new
    @lancamentos = Lancamento.all
    @lancamentorapidos = Lancamentorapido.all
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all
  end

  def loadgrid
    render :partial => 'grid'
  end

  def build_query
    query = Lancamento.unscoped

    #query = Lancamento.padrao
    query = query.scoped_by_centrodecusto_id(params[:centrodecusto]) unless  params[:centrodecusto].nil?
    query = query.scoped_by_category_id(params[:categoria]) unless  params[:categoria].nil?
    query = query.por_descricao('%' + params[:descricao] + '%') unless params[:descricao].nil?
    query = query.scoped_by_status_cd(params[:status]) unless params[:status].nil?
    query = query.a_partir_de(params[:datavencimentode]) unless params[:datavencimentode].nil?
    query = query.ate(params[:datavencimentoate]) unless params[:datavencimentoate].nil?

    if (params[:receita] == 'S' and params[:despesa] == 'N')
      query = query.receitas

    elsif (params[:receita] == 'N' and params[:despesa] == 'S')
      query = query.despesas

    end

    if not params[:valor].nil? then
      case params[:seletorvalor]
        when "="
          query = query.valor_igual(params[:valor])
        when "<"
          query = query.valor_menor(params[:valor])
        when ">"
          query = query.valor_maior(params[:valor])
      end

    end

    # Fixed to accept datatable params
    if params[:sEcho].nil? then
      query = query.paginate(:page => "1", :per_page => 10)
    else
      query = query.paginate(:page => params[:sEcho], :per_page => 10)
    end

    #if params[:page].nil? then
    #  query = query.paginate(:page => "1", :per_page => 10)
    #else
    #  query = query.paginate(:page => params[:page], :per_page => 10)
    #end


    return query
  end

  # GET /lancamentos
  # GET /lancamentos.json
  def index
    # Series dos graficos
    begin
      @ano = Time.now.year
      @ano = params[:ano] unless params[:ano].blank?
      @dt = DateTime.new(@ano, 1, 1)

      @tabSelection = params[:tab]

      @lancamentos = Lancamento.padrao

    rescue
      @err = "Error #{$!}"
    ensure
    end


    # Notificações
    @notificacoes = Hash.new { |hash, key| hash[key] = Hash.new }

    # Receitas Atrasadas
    notif_receitas_atrasadas = Lancamento.receitas.abertos.ate(Date.today)
    if notif_receitas_atrasadas.count > 0
      @notificacoes[Random.new_seed] = {
          :text => sprintf('Você tem %d Receitas Atrasadas.', notif_receitas_atrasadas.count),
          :can_close => true,
          :class => 'notification_information',
          :filter_string => sprintf('receita=S&despesa=N&datavencimentode=1970-01-01&datavencimentoate=%s&status=%s', Date.today.strftime('%Y-%m-%d'), Lancamento.aberto)
      }
    end

    # Despesas Vencidas
    notif_despesas_vencidas = Lancamento.despesas.abertos.ate(Date.today)
    if notif_receitas_atrasadas.count > 0
      @notificacoes[Random.new_seed] = {
          :text => sprintf('Você tem %d Despesas Vencidas.', notif_despesas_vencidas.count),
          :can_close => true,
          :class => 'notification_success',
          :filter_string => sprintf('receita=N&despesa=S&datavencimentode=1970-01-01&datavencimentoate=%s&status=%s', Date.today.strftime('%Y-%m-%d'), Lancamento.aberto)
      }
    end

    # Receitas a Receber
    notif_receitas_a_receber = Lancamento.receitas.abertos.range(Date.today, Date.today + Configurable.number_of_future_days)
    if notif_receitas_a_receber.count > 0
      @notificacoes[Random.new_seed] = {
          :text => sprintf('Você tem %d Receitas a receber nos próximos %d dias.', notif_receitas_a_receber.count, Configurable.number_of_future_days),
          :can_close => true,
          :class => 'notification_warning',
          :filter_string => sprintf('receita=S&despesa=N&datavencimentode=%s&datavencimentoate=%s&status=%s', Date.today.strftime('%Y-%m-%d'), (Date.today + Configurable.number_of_future_days).strftime('%Y-%m-%d'), Lancamento.aberto)
      }
    end

    # Despesas Vincendas
    notif_despesas_vincendas = Lancamento.despesas.abertos.range(Date.today, Date.today + Configurable.number_of_future_days)
    if notif_despesas_vincendas.count > 0
      @notificacoes[Random.new_seed] = {
          :text => sprintf('Você tem %d Despesas a vencer nos próximos %d dias.', notif_despesas_vincendas.count, Configurable.number_of_future_days),
          :can_close => true,
          :class => 'notification_attention',
          :filter_string => sprintf('receita=N&despesa=S&datavencimentode=%s&datavencimentoate=%s&status=%s', Date.today.strftime('%Y-%m-%d'), (Date.today + Configurable.number_of_future_days).strftime('%Y-%m-%d'), Lancamento.aberto)
      }
    end
  end

  def new
    @lancamento = Lancamento.new
  end

  # GET /lancamentos/1/edit
  def edit

    DebugLog(params.inspect)

    @lancamento = Lancamento.find(params[:id])

    if (@lancamento.despesa?)
      @lancamento.valor = @lancamento.valor * -1
    end

    #@lancamentorapidos = Lancamentorapido.all
    #@categorias = Category.all
    #@centrosdecusto = Centrodecusto.all
  end

  # POST /lancamentos
  # POST /lancamentos.json
  def create
    DebugLog('Lancamento - params: ' + params.inspect)
    params[:lancamento][:valor] = params[:lancamento][:valor].gsub('.', '').gsub(',', '.')

    if Lancamento.create_lancamento(params)
      flash[:notice] = 'Lancamento com sucesso.'
    else
      flash[:notice] = 'Erro ao salvar o lancamento.'
    end

    @lancamentos = Lancamento.unscoped.all
  end

  #create

  # PUT /lancamentos/1
  # PUT /lancamentos/1.json
  def update

    DebugLog('Lancamento - params: ' + params.inspect)
    params[:lancamento][:valor] = params[:lancamento][:valor].gsub('.', '').gsub(',', '.')
    @lancamento = Lancamento.find(params[:id])

    @lancamento.category = Category.find_or_create_by_descricao(params[:category]) unless params[:category].blank?
    @lancamento.centrodecusto = Centrodecusto.find_or_create_by_descricao(params[:centrodecusto]) unless params[:centrodecusto].blank?


    @quitado = params[:quitado]
    @freqParcelas = params[:freqParcelas] unless params[:freqParcelas].blank?
    @numParcelas = Integer(params[:numParcelas]) unless params[:numParcelas].blank?

    @freqAgendamentos = params[:freqAgendamentos] unless params[:freqAgendamentos].blank?
    @numAgendamentos = Integer(params[:numAgendamentos]) unless params[:numAgendamentos].blank?

    #Validações padrão
    @lancamento.tipo = :receita if @lancamento.tipo.blank?
    @lancamento.valor = 0 if @lancamento.valor.blank?

    @numParcelas = 1 if @numParcelas.blank?
    @numAgendamentos = 1 if @numAgendamentos.blank?

    @freqParcelas = 'Mensal' if @freqParcelas.blank?
    @freqAgendamentos = 'Mensal' if @freqAgendamentos.blank?


    if @quitado == 'true'
      @lancamento.status = :quitado
      @lancamento.dataacao = Date.today.strftime('%d-%m-%Y')
    end

    #Verifica se o registro ja possui parcela, caso contrário não será permitido parcelamento
    # 2013-05-02: Quando editando o primeiro registro deve ser transformado em um registro parcelado

    if @numParcelas > 1 and !@lancamento.has_parcelamento?
      # Cria o registro de parcela
      @parcela = Parcela.new
      @parcela.num_parcelas = @numParcelas

      if @parcela.save then
        @lancamento_original = @lancamento.dup
        @lancamento.valor = @lancamento.valor/@numParcelas

        @lancamento.descricao = "#{@lancamento.descricao} - #{@freqParcelas} - (#{1}/#{@numParcelas})"
        @lancamento.parcela = @parcela

        @lancamento.save
        (2..@numParcelas).each do |i|
          @lancamento_parcela = Lancamento.new
          @lancamento_parcela = @lancamento_original.dup
          @lancamento_parcela.valor = @lancamento_original.valor/@numParcelas

          @lancamento_parcela.datavencimento = case @freqParcelas
                                                 when 'Semanal' then
                                                   @lancamento_parcela.datavencimento + (i-1).weeks
                                                 when 'Mensal' then
                                                   @lancamento_parcela.datavencimento + (i-1).months
                                                 when 'Semestral' then
                                                   @lancamento_parcela.datavencimento + ((i-1)*6).months
                                                 when 'Anual' then
                                                   @lancamento_parcela.datavencimento + (i-1).years
                                                 else
                                                   @lancamento_parcela.datavencimento
                                               end

          @lancamento_parcela.descricao = "#{@lancamento_original.descricao} - #{@freqParcelas} - (#{i}/#{@numParcelas})"
          @lancamento_parcela.parcela = @parcela

          @lancamento_parcela.save
        end #do
      end # if @parcela.save
    end # @numParcelas > 1

    #Verifica se o registro ja possui agendamento, caso contrário não será permitido agendamento
    if @numAgendamentos > 1 and !@lancamento.has_agendamento?
      # Cria o registro de agendamento
      @agendamento = Agendamento.new
      @agendamento.num_agendamentos = @numAgendamentos

      if @agendamento.save
        (2..@numAgendamentos).each do |i|
          @lancamento_agendamento = Lancamento.new
          @lancamento_agendamento = @lancamento.dup

          @lancamento_agendamento.datavencimento = case @freqAgendamentos
                                                     when 'Semanal' then
                                                       @lancamento_agendamento.datavencimento + (i-1).weeks
                                                     when 'Mensal' then
                                                       @lancamento_agendamento.datavencimento + (i-1).months
                                                     when 'Semestral' then
                                                       @lancamento_agendamento.datavencimento + ((i-1)*6).months
                                                     when 'Anual' then
                                                       @lancamento_agendamento.datavencimento + (i-1).years
                                                     else
                                                       @lancamento_agendamento.datavencimento
                                                   end
          @lancamento_agendamento.agendamento = @agendamento

          @lancamento_agendamento.save
        end #do
      end #@agendamento.save
    end

    if (!(@numParcelas > 1 and @lancamento.has_parcelamento?) and !(@numAgendamentos > 1 and @lancamento.has_agendamento?))
      if @lancamento.update_attributes(params[:lancamento])
        flash[:notice] = 'Sucesso - update'
      else
        flash[:notice] = 'Falha ao atualizar o lancamento'
      end
    end
    @lancamentos = Lancamento.unscoped.all
    @lancamento = Lancamento.new
  end

  # DELETE /lancamentos/1
  # DELETE /lancamentos/1.json
  def destroy

    @lancamento = Lancamento.find(params[:id])

    if @lancamento.is_original? then
      @lancamento.lancamento_estornado.destroy
      #@lancamento.lancamento_estornado.cancel
    end

    if @lancamento.destroy
      #if @lancamento.cancel
      flash[:notice] = 'Sucesso - destroy'
    else
      flash[:notice] = 'Erro ao destroy lancamento'
    end

    # Recarrega as informações de lançamentos
    @lancamento = Lancamento.new
    @lancamentos = Lancamento.unscoped.all
    #redirect_to lancamentos_url
    #@lancamento.cancel
  end

# Custom controllers
  def quitar
    @lancamento = Lancamento.find(params[:id])
    if @lancamento.quitado? #and !@lancamento.estornado?
      @lancamento.status = :aberto
      @lancamento.dataacao = nil
      if @lancamento.save
        #flash[:notice] = 'Sucesso ao reverter quitar'
      else
        #flash[:notice] = 'Erro ao reverter quitar'
      end
    else
      if @lancamento.aberto?
        @lancamento.status = :quitado
        @lancamento.dataacao = Date.today.strftime("%d-%m-%Y")
        if @lancamento.save
          # flash[:notice] = 'Lancamento quitado com sucesso'
        else
          # flash[:notice] = 'Erro ao quitar lancamento'
        end
      else
        #flash[:notice] = 'Lancamento so pode estar ou quitado ou aberto'
      end

    end

    # render :layout => false

  end

  def estornar
    DebugLog('Params: ' + params.inspect);

    @lancamento = Lancamento.find(params[:id])
    if @lancamento.quitado? and !@lancamento.has_estorno? then
# Altera os valores do lançamento duplicado      
      @lancamento_estornado = @lancamento.dup
      @lancamento_estornado.descricao = "#{@lancamento_estornado.descricao} - ESTORNO"

      if @lancamento.receita? then

        @lancamento_estornado.tipo = :despesa

      else

        @lancamento_estornado.tipo = :receita

      end

      @lancamento_estornado.dataacao = Date.today.strftime("%d-%m-%Y")
      @lancamento_estornado.status = :estornado
# Salva o lançamento estornado para recuperar o id       
      @lancamento_estornado.save

      @lancamento.lancamento_estornado = @lancamento_estornado
      @lancamento.status = :estornado

      @lancamento.save
    else
      if @lancamento.has_estorno? then
# Verifica se este é o original          
        if @lancamento.is_original? then
          @lancamento.status = :aberto
          @lancamento.dataacao = nil
          @lancamento.lancamento_estornado.cancel
          @lancamento.lancamento_estornado = nil
          @lancamento.save
        else
          @lancamento.lancamento_original.status = :aberto
          @lancamento.lancamento_original.dataacao = nil
          @lancamento.lancamento_original.save

          @lancamento.cancel
        end
      end
    end
    @lancamentos = Lancamento.unscoped.all
    @lancamento = Lancamento.new
  end

  def cancelar
    @lancamento = Lancamento.find(params[:id])
    if @lancamento.aberto? #and !@lancamento.estornado?
      @lancamento.status = :cancelado
      @lancamento.dataacao = Date.today.strftime("%d-%m-%Y")
      if @lancamento.save
        #flash[:notice] = 'Sucesso ao reverter quitar'
      else
        #flash[:notice] = 'Erro ao reverter quitar'
      end

      #flash[:notice] = 'Lancamento so pode estar ou quitado ou abert
    end

    # render :layout => false

  end


  def print
    render :print, :layout => false
  end

  def getLancamento

    if not Lancamento.find(params[:id]).nil?

      @lancamento = Lancamento.find(params[:id])

      render :json => {
          :rows => @lancamento

      }
    end
  end

  def importar
    if request.post?
      uploaded_file = params[:file]
      case File.extname(uploaded_file.original_filename.to_s)
        when '.xls' then
          spreadsheet = Roo::Excel::new(uploaded_file.path, nil, :ignore)
        when '.xlsx' then
          spreadsheet = Roo::Excelx::new(uploaded_file.path, nil, :ignore)
        else
          raise 'Formato de Arquivo Desconhecido!'
      end
      header = spreadsheet.row(1) #sempre considerar a primeira linha como cabeçalho
      params[:lancamento] = {}
      lastrow = spreadsheet.last_row
      success = 0
      (2..lastrow).each do |i|
        case spreadsheet.cell(i, 'A')
          when 'D' then
            params[:lancamento][:tipo] = 'despesa'
          when 'R' then
            params[:lancamento][:tipo] = 'receita'
          else
            next
        end
        params[:lancamento][:descricao] = spreadsheet.cell(i, 'B')
        params[:lancamento][:datavencimento] = spreadsheet.cell(i, 'C')
        params[:lancamento][:valor] = spreadsheet.cell(i, 'D')
        params[:category] = spreadsheet.cell(i, 'E')
        params[:centrodecusto] = spreadsheet.cell(i, 'F')
        params[:numParcelas] = spreadsheet.cell(i, 'G')

        if Lancamento.create_lancamento(params)
          success += 1
        end

      end
      flash[:notice] = sprintf('%d de %d registros importados!', success, lastrow-1)
    end
  end
end
