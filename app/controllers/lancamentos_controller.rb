#!/bin/env ruby
# encoding: utf-8
require 'roo'
#require 'iconv'

class LancamentosController < ApplicationController
  include ApplicationHelper
  include LancamentosHelper

  before_filter :load

  # GET /lancamentos/filter
  # GET /lancamentos/filter.json

  def filter
    query = build_query()
    @lancamentos = query


    render :layout => nil
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
    queryapoio = Lancamento.unscoped
    #queryapoio = Lancamento.padrao
    queryapoio = queryapoio.scoped_by_centrodecusto_id(params[:centrodecusto]) unless  params[:centrodecusto].nil?
    queryapoio = queryapoio.scoped_by_category_id(params[:categoria]) unless  params[:categoria].nil?
    queryapoio = queryapoio.por_descricao('%' + params[:descricao] + '%') unless params[:descricao].nil?
    queryapoio = queryapoio.scoped_by_status_cd(params[:status]) unless params[:status].nil?
    queryapoio = queryapoio.a_partir_de(params[:datavencimentode]) unless params[:datavencimentode].nil?
    queryapoio = queryapoio.ate(params[:datavencimentoate]) unless params[:datavencimentoate].nil?

    if (params[:receita] == 'S' and params[:despesa] == 'N')
      queryapoio = queryapoio.receitas

    elsif (params[:receita] == 'N' and params[:despesa] == 'S')
      queryapoio = queryapoio.despesas

    end

    if not params[:valor].nil? then
      case params[:seletorvalor]
        when "="
          queryapoio = queryapoio.valor_igual(params[:valor])

        when "<"

          queryapoio = queryapoio.valor_menor(params[:valor])

        when ">"

          queryapoio = queryapoio.valor_maior(params[:valor])

      end

    end

    if params[:page].nil? then

      queryapoio = queryapoio.paginate(:page => "1", :per_page => 1000)

    else

      queryapoio = queryapoio.paginate(:page => params[:page], :per_page => 1000)

    end


    query = queryapoio
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
