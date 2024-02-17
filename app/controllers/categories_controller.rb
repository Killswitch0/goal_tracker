class CategoriesController < ApplicationController
  before_action :redirect_user
  before_action :set_category, only: %i[show edit destroy]

  # GET /categories
  #----------------------------------------------------------------------------
  def index
    @categories = current_user.categories
  end

  # GET /categories/1
  #----------------------------------------------------------------------------
  def show; end

  # GET /categories/1
  #----------------------------------------------------------------------------
  def edit; end

  # GET categories/new
  #----------------------------------------------------------------------------
  def new
    @category = Category.new
  end

  # POST /categories
  #----------------------------------------------------------------------------
  def create
    @category = current_user.categories.build(category_params)

    respond_to do |format|
      if @category.save
        flash[:noticed] = t('.success')
        format.html { redirect_to goals_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  #----------------------------------------------------------------------------
  def destroy
    if @category.goals.any?
      flash[:danger] = t('.fail')
    else
      @category.destroy
      flash[:noticed] = t('.success')
    end

    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :user_id)
  end
end
