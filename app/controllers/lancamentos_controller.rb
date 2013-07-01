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
  #def reports
  #  @tabSelection = params[:tab]
  #  @dt = DateTime.now
  #
  #  case @tabSelection
  #    when 'receita' then
  #      @report_series_zone_1 = Lancamento.find_by_sql(receita_series_query(@dt))
  #      @report_series_zone_2 = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt).to_sql)
  #      @report_series_zone_3 = Lancamento.find_by_sql(receita_por_status_series_query(@dt).to_sql)
  #    when 'despesa' then
  #      #@report_series_zone_1 = Lancamento.find_by_sql(despesa_series_query(@dt))
  #      #@report_series_zone_2 = Lancamento.find_by_sql(despesa_por_categoria_series_query(@dt).to_sql)
  #      #@report_series_zone_3 = Lancamento.find_by_sql(despesa_por_centrodecusto_series_query(@dt).to_sql)
  #      #@report_series_zone_3 = Lancamento.find_by_sql(despesa_por_categoria_series_query(@dt).to_sql)
  #
  #      @report_series_zone_1 = Lancamento.find_by_sql(receita_series_query(@dt))
  #      @report_series_zone_2 = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt).to_sql)
  #      @report_series_zone_3 = Lancamento.find_by_sql(receita_por_status_series_query(@dt).to_sql)
  #    else
  #      @report_series_zone_1 = Lancamento.find_by_sql(receita_series_query(@dt))
  #      @report_series_zone_2 = Lancamento.find_by_sql(receita_por_categoria_series_query(@dt).to_sql)
  #      @report_series_zone_3 = Lancamento.find_by_sql(receita_por_status_series_query(@dt).to_sql)
  #  end
  #end

  def build_query
    queryapoio = Lancamento.unscoped
    queryapoio = queryapoio.scoped_by_centrodecusto_id(params[:centrodecusto]) unless  params[:centrodecusto].nil?
    queryapoio = queryapoio.scoped_by_category_id(params[:categoria]) unless  params[:categoria].nil?
    queryapoio = queryapoio.por_descricao('%' + params[:descricao] + '%') unless params[:descricao].nil?
    queryapoio = queryapoio.receitas  unless params[:receitas].nil?
	  queryapoio = queryapoio.scoped_by_status_cd(params[:status]) unless params[:status].nil?
	
    if params[:page].nil? then

      queryapoio = queryapoio.paginate(:page => "1", :per_page => 20)

    else

      queryapoio = queryapoio.paginate(:page => params[:page], :per_page => 20)

    end





    query =  queryapoio
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

      @receita_series = Lancamento.find_by_sql(receita_series_query(@dt))
      @despesa_series = Lancamento.find_by_sql(despesa_series_query(@dt))
      @caixa_series = Lancamento.find_by_sql(caixa_series_query(@dt))
    rescue
      @err = "Error #{$!}"
    ensure

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

    @lancamento = Lancamento.new(params[:lancamento])

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

    if @numParcelas > 1
      # Cria o registro de parcela
      @parcela = Parcela.new
      @parcela.num_parcelas = @numParcelas

      if @parcela.save then
        (1..@numParcelas).each do |i|
          @lancamento_parcela = Lancamento.new
          @lancamento_parcela = @lancamento.dup
          @lancamento_parcela.valor = @lancamento.valor/@numParcelas

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

          @lancamento_parcela.descricao = "#{@lancamento.descricao} - #{@freqParcelas} - (#{i}/#{@numParcelas})"
          @lancamento_parcela.parcela = @parcela

          @lancamento_parcela.save
        end #do     
      end # if @parcela.save
    end # @numParcelas > 1


    if @numAgendamentos > 1
      # Cria o registro de agendamento
      @agendamento = Agendamento.new
      @agendamento.num_agendamentos = @numAgendamentos

      if @agendamento.save
        (1..@numAgendamentos).each do |i|
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
    # TODO: Criar uma tabela com o registro de todas as mensagens do sistema
    if (!(@numParcelas > 1) and !(@numAgendamentos > 1))
      if @lancamento.save
        flash[:notice] = 'Lancamento com sucesso.'
      else
        flash[:notice] = 'Erro ao salvar o lancamento.'
      end
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
        flash[:notice] = 'Sucesso ao reverter quitar'
      else
        flash[:notice] = 'Erro ao reverter quitar'
      end
    else
      if @lancamento.aberto?
        @lancamento.status = :quitado
        @lancamento.dataacao = Date.today.strftime("%d-%m-%Y")
        if @lancamento.save
          flash[:notice] = 'Lancamento quitado com sucesso'
        else
          flash[:notice] = 'Erro ao quitar lancamento'
        end
      else
        flash[:notice] = 'Lancamento so pode estar ou quitado ou aberto'
      end

    end
    @lancamentos = Lancamento.unscoped.all
    @lancamento = Lancamento.new
  end

  def estornar
    DebugLog('Params: ' + params.inspect);

    @lancamento = Lancamento.find(params[:id])
    if @lancamento.quitado? and !@lancamento.has_estorno? then
# Altera os valores do lançamento duplicado      
      @lancamento_estornado = @lancamento.dup
      @lancamento_estornado.descricao = "#{@lancamento_estornado.descricao} - ESTORNO"
      @lancamento_estornado.tipo = :receita unless @lancamento_estornado.receita?
      @lancamento_estornado.tipo = :despesa unless @lancamento_estornado.despesa?
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


end
