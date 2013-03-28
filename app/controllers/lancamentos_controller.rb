class LancamentosController < ApplicationController
  include ApplicationHelper
  
  # GET /lancamentos
  # GET /lancamentos.json
  def index  
	@lancamento = Lancamento.new
	#Aqui iremos implementar os filtros, pelo que eu entendi.
    @lancamentos = Lancamento.all
    
# Active records auxiliares
    @lancamentorapidos = Lancamentorapido.all    
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lancamentos }
    end
  end

  # GET /lancamentos/1
  # GET /lancamentos/1.json
  def show
    
    @lancamento = Lancamento.find(params[:id])
    
    @lancamentorapidos = Lancamentorapido.all
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lancamento }
    end
  end

  # GET /lancamentos/new
  # GET /lancamentos/new.json
  def new
    
    @lancamento = Lancamento.new
    
    @lancamentorapidos = Lancamentorapido.all
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all
#    @lancamentopadrao = Lancamentopadrao.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lancamento }
    end
  end

  # GET /lancamentos/1/edit
  def edit
    
    DebugLog(params.inspect)
    
    @lancamento = Lancamento.find(params[:id])
    
    @lancamentorapidos = Lancamentorapido.all
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all
  end

  # POST /lancamentos
  # POST /lancamentos.json
  def create 
    @lancamento = Lancamento.new(params[:lancamento])
# Verifica a categoria que foi enviada
#    @categoria = Category.find(params[:category]) unless params[:category] == "0"
#    @lancamento.category = @categoria unless @categoria.nil?
#    DebugLog("Categoria - id: " + @categoria.id.inspect) unless @categoria.nil?
    
# Verifica o centro de custo que foi enviado
#    @centrodecusto = Centrodecusto.find(params[:centrodecusto]) unless params[:centrodecusto] == "0"
#    @lancamento.centrodecusto = @centrodecusto unless @centrodecusto.nil?
#    DebugLog("CentrodeCusto - id: " + @centrodecusto.id.inspect) unless @centrodecusto.nil?            
    
    @quitado = params[:quitado]
    
    #Validações padrão
    @lancamento.tipo = :receita if @lancamento.tipo.blank?
#    @lancamento.status = :aberto if @lancamento.status.blank?
    @lancamento.valor = 0 if @lancamento.valor.blank?  
#    @lancamento.category = Category.find_by_descricao(Configurable.categoria_padrao) if @lancamento.category.nil?
#    @lancamento.centrodecusto = Centrodecusto.find_by_descricao(Configurable.centrodecusto_padrao) if @lancamento.centrodecusto.nil?
         
    if @quitado == "true" then     
      @lancamento.status = :quitado      
      @lancamento.dataacao = Date.today.strftime("%d-%m-%Y")           
    end
    
# Logging income
    DebugLog("Lancamento - params: " + params.inspect)    
    DebugLog("Lancamento - desc: " + @lancamento.descricao.inspect)
    DebugLog("Lancamento - status: " + @lancamento.status.inspect)
    DebugLog("Lancamento - tipo: " + @lancamento.tipo.inspect)
    DebugLog("Lancamento - datavencimento: " + @lancamento.datavencimento.inspect)
    DebugLog("Lancamento - dataacao: " + @lancamento.dataacao.inspect)
    DebugLog("Lancamento - valor: " + @lancamento.valor.inspect)
    DebugLog("Lancamento - categoria: " + @lancamento.category.descricao.inspect) unless @lancamento.category.nil?
    DebugLog("Lancamento - centrodecusto: " + @lancamento.centrodecusto.descricao.inspect) unless @lancamento.centrodecusto.nil?    
         
    respond_to do |format|
      if @lancamento.save
        #format.html { redirect_to @lancamento, notice: 'Lancamento was successfully created.' } Aqui iremos fazer a redire��o direto para o index.
		format.html { redirect_to '/lancamentos'}
        format.json { render json: @lancamento, status: :created, location: @lancamento }
      else
        format.html { render action: "new" }
        format.json { render json: @lancamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lancamentos/1
  # PUT /lancamentos/1.json
  def update
    
    @lancamento = Lancamento.find(params[:id])
            
    # Verifica a categoria que foi enviada
#    @categoria = Category.find(params[:category]) unless params[:category] == "0"
#    @lancamento.category = @categoria unless @categoria.nil?
#    DebugLog("Categoria - id: " + @categoria.id.inspect) unless @categoria.nil?
    
    # Verifica o centro de custo que foi enviado
#    @centrodecusto = Centrodecusto.find(params[:centrodecusto]) unless params[:centrodecusto] == "0"
#    @lancamento.centrodecusto = @centrodecusto unless @centrodecusto.nil?
#    DebugLog("CentrodeCusto - id: " + @centrodecusto.id.inspect) unless @centrodecusto.nil?            
    
    @quitado = params[:quitado]
    
    #Validações padrão
    @lancamento.tipo = :receita if @lancamento.tipo.blank?
#    @lancamento.status = :aberto if @lancamento.status.blank?
    @lancamento.valor = 0 if @lancamento.valor.blank?  
#    @lancamento.category = Category.find_by_descricao(Configurable.categoria_padrao) if @lancamento.category.nil?
#    @lancamento.centrodecusto = Centrodecusto.find_by_descricao(Configurable.centrodecusto_padrao) if @lancamento.centrodecusto.nil?
         
    if @quitado == "true" then     
      @lancamento.status = :quitado      
      @lancamento.dataacao = Date.today.strftime("%d-%m-%Y")           
    end
    
# Logging income
    DebugLog("Lancamento - params: " + params.inspect)    
    DebugLog("Lancamento - desc: " + @lancamento.descricao.inspect)
    DebugLog("Lancamento - status: " + @lancamento.status.inspect)
    DebugLog("Lancamento - tipo: " + @lancamento.tipo.inspect)
    DebugLog("Lancamento - datavencimento: " + @lancamento.datavencimento.inspect)
    DebugLog("Lancamento - dataacao: " + @lancamento.dataacao.inspect)
    DebugLog("Lancamento - valor: " + @lancamento.valor.inspect)
    DebugLog("Lancamento - categoria: " + @lancamento.category.descricao.inspect) unless @lancamento.category.nil?
    DebugLog("Lancamento - centrodecusto: " + @lancamento.centrodecusto.descricao.inspect) unless @lancamento.centrodecusto.nil?  
    

    respond_to do |format|
      if @lancamento.update_attributes(params[:lancamento])
        format.html { redirect_to @lancamento, notice: 'Lancamento was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lancamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lancamentos/1
  # DELETE /lancamentos/1.json
  def destroy
    
    @lancamento = Lancamento.find(params[:id])
#    @lancamento.destroy
    @lancamento.cancel    

    respond_to do |format|
      format.html { redirect_to lancamentos_url }
      format.json { head :no_content }
    end
  end
  
# Custom controllers
  def quitar
    DebugLog("Params: " + params.inspect);        
    
    @lancamento = Lancamento.find(params[:id])    
    if @lancamento.quitado? then
      @lancamento.status = :aberto
      @lancamento.dataacao = nil
      @lancamento.save
    else
      @lancamento.status = :quitado
      @lancamento.dataacao = Date.today.strftime("%d-%m-%Y")
      @lancamento.save
    end      
  end
  
  def estornar
    DebugLog("Params: " + params.inspect);
    
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
  end  
end
