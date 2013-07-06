class LancamentorapidosController < ApplicationController
   include ApplicationHelper
  # GET /lancamentorapidos
  # GET /lancamentorapidos.json
  def index  
    @lancamentorapido = Lancamentorapido.new  
    @lancamentorapidos = Lancamentorapido.all
    
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lancamentorapidos }
    end
  end

   def list
     @list = Lancamentorapido.all(:select=> 'id, descricao as text')
     respond_to do |format|
       format.json { render json: @list }
     end
   end

  # GET /lancamentorapidos/1
  # GET /lancamentorapidos/1.json
  def show
    
    @lancamentorapido = Lancamentorapido.find(params[:id])
    
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lancamentorapido }
    end
  end

  # GET /lancamentorapidos/new
  # GET /lancamentorapidos/new.json
  def new
    DebugLog(params.inspect)
    @lancamentorapido = Lancamentorapido.new
    
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lancamentorapido }
    end
  end

  # GET /lancamentorapidos/1/edit
  def edit
    
    DebugLog(params.inspect)
    
    @lancamentorapido = Lancamentorapido.find(params[:id])
    
    @categorias = Category.all
    @centrosdecusto = Centrodecusto.all
  end

  # POST /lancamentorapidos
  # POST /lancamentorapidos.json
  def create 
    @lancamentorapido = Lancamentorapido.new(params[:lancamentorapido])
    
    #Validações padrão
    @lancamentorapido.tipo = :receita if @lancamentorapido.tipo.blank?
    @lancamentorapido.valor = 0 if @lancamentorapido.valor.blank?              
         
    respond_to do |format|
      if @lancamentorapido.save
        format.html { redirect_to lancamentorapidos_path, notice: 'Lancamento was successfully created.' } 
#        format.html { redirect_to '/lancamentorapidos'}
        format.json { render json: lancamentorapidos_path, status: :created, location: @lancamentorapido }
      else
        format.html { render action: "new" }
        format.json { render json: @lancamentorapido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lancamentorapidos/1
  # PUT /lancamentorapidos/1.json
  def update
    
    @lancamentorapido = Lancamentorapido.find(params[:id])        
           
    #Validações padrão
    @lancamentorapido.tipo = :receita if @lancamentorapido.tipo.blank?
    @lancamentorapido.valor = 0 if @lancamentorapido.valor.blank?              
    

    respond_to do |format|
      if @lancamentorapido.update_attributes(params[:lancamentorapido])
        format.html { redirect_to lancamentorapidos_path, notice: 'Lancamento was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lancamentorapido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lancamentorapidos/1
  # DELETE /lancamentorapidos/1.json
  def destroy
    
    @lancamentorapido = Lancamentorapido.find(params[:id])
    @lancamentorapido.destroy    

    respond_to do |format|
      format.html { redirect_to lancamentorapidos_path }
      format.json { head :no_content }
    end
  end
end
