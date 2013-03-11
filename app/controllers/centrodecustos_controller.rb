class CentrodecustosController < ApplicationController
  # GET /centrodecustos
  # GET /centrodecustos.json
  def index
    @centrodecustos = Centrodecusto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @centrodecustos }
    end
  end

  # GET /centrodecustos/1
  # GET /centrodecustos/1.json
  def show
    @centrodecusto = Centrodecusto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @centrodecusto }
    end
  end

  # GET /centrodecustos/new
  # GET /centrodecustos/new.json
  def new
    @centrodecusto = Centrodecusto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @centrodecusto }
    end
  end

  # GET /centrodecustos/1/edit
  def edit
    @centrodecusto = Centrodecusto.find(params[:id])
  end

  # POST /centrodecustos
  # POST /centrodecustos.json
  def create
    @centrodecusto = Centrodecusto.new(params[:centrodecusto])

    respond_to do |format|
      if @centrodecusto.save
        format.html { redirect_to @centrodecusto, notice: 'Centrodecusto was successfully created.' }
        format.json { render json: @centrodecusto, status: :created, location: @centrodecusto }
      else
        format.html { render action: "new" }
        format.json { render json: @centrodecusto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /centrodecustos/1
  # PUT /centrodecustos/1.json
  def update
    @centrodecusto = Centrodecusto.find(params[:id])

    respond_to do |format|
      if @centrodecusto.update_attributes(params[:centrodecusto])
        format.html { redirect_to @centrodecusto, notice: 'Centrodecusto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @centrodecusto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /centrodecustos/1
  # DELETE /centrodecustos/1.json
  def destroy
    @centrodecusto = Centrodecusto.find(params[:id])
    @centrodecusto.destroy

    respond_to do |format|
      format.html { redirect_to centrodecustos_url }
      format.json { head :no_content }
    end
  end
end
