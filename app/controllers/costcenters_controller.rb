class CostcentersController < ApplicationController
  # GET /costcenters
  # GET /costcenters.json
  def index
    @costcenters = Costcenter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @costcenters }
    end
  end

  # GET /costcenters/1
  # GET /costcenters/1.json
  def show
    @costcenter = Costcenter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @costcenter }
    end
  end

  # GET /costcenters/new
  # GET /costcenters/new.json
  def new
    @costcenter = Costcenter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @costcenter }
    end
  end

  # GET /costcenters/1/edit
  def edit
    @costcenter = Costcenter.find(params[:id])
  end

  # POST /costcenters
  # POST /costcenters.json
  def create
    @costcenter = Costcenter.new(params[:costcenter])

    respond_to do |format|
      if @costcenter.save
        format.html { redirect_to @costcenter, notice: 'Costcenter was successfully created.' }
        format.json { render json: @costcenter, status: :created, location: @costcenter }
      else
        format.html { render action: "new" }
        format.json { render json: @costcenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /costcenters/1
  # PUT /costcenters/1.json
  def update
    @costcenter = Costcenter.find(params[:id])

    respond_to do |format|
      if @costcenter.update_attributes(params[:costcenter])
        format.html { redirect_to @costcenter, notice: 'Costcenter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @costcenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /costcenters/1
  # DELETE /costcenters/1.json
  def destroy
    @costcenter = Costcenter.find(params[:id])
    @costcenter.destroy

    respond_to do |format|
      format.html { redirect_to costcenters_url }
      format.json { head :no_content }
    end
  end
end
