class CategoriesController < ApplicationController
  before_action :redirect_user
  before_action :set_category, only: %i[ show edit destroy]

  def index
    @categories = current_user.categories
  end

  def show; end

  def edit; end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to goals_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.goals.any?
      flash[:danger] = "Category must be empty."
      redirect_to categories_path
    else
      @category.destroy
      flash[:noticed] = "Category has been successfully destroyed."
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
