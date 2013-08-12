class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.json

  before_filter :load

  def load
    @category = Category.new
    @categories = Category.all
  end

  def index
    @categories = Category.all

 #   respond_to do |format|
 #     format.html # index.html.erb
 #     format.json { render json: @categories }
 #   end
  end

  def list
    @list = Category.all(:select => 'id, descricao as text')
    respond_to do |format|
      format.json { render json: @list }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @category }
  #  end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

  #  @categories = Category.all

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @category }
  #  end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @categories = Category.all
    @categories.delete(@category)
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:notice] = 'Categoria criada com sucesso.'
    else
      flash[:notice] = 'Erro ao salvar a categoria.'
    end

  #  respond_to do |format|
  #    if @category.save
  #      format.html { redirect_to categories_path}
  #      format.json { render json: @category, status: :created, location: @category }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @category.errors, status: :unprocessable_entity }
  #    end
  #  end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

      if @category.update_attributes(params[:category])
        flash[:notice] = 'Sucesso - update'
      else
        flash[:notice] = 'Falha ao atualizar a categoria'
      end

  #  respond_to do |format|
  #    if @category.update_attributes(params[:category])
  #      format.html { redirect_to categories_path}
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @category.errors, status: :unprocessable_entity }
        
  #    end
  #  end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  def tree

      @report_series = Category.all

      unless @report_series.nil?
        @json_rows = Array.new
        @report_series.each do |serie|
          @json_row = Array.new
          @json_row.push("#{serie.descricao}")

          serie.parent.nil? ? @json_row.push(nil) : @json_row.push("#{serie.parent.descricao}")

          @json_row.push('')
          @json_row.push("#{serie.id}")
          @json_row.push("#{serie.parent_id}")
          @json_rows.push(@json_row)
        end

        render :json => {
            :cols => [['string', 'descricao'], ['string', 'parent'], ['string','Tooltip'],['string','id'],['string','parentid']],
            :rows => @json_rows
        }
      end
  end

end
