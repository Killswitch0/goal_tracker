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

    if @category.save
      flash[:noticed] = t('.success')
      redirect_to goals_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  #----------------------------------------------------------------------------
  def destroy
    if @category.goals.any?
      flash[:danger] = t('.fail')
      redirect_to categories_path
    else
      @category.destroy
      flash[:noticed] = t('.success')
      redirect_to categories_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :user_id)
  end
end
