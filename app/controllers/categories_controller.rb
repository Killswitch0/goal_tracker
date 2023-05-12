class CategoriesController < ApplicationController
  before_action :redirect_user
  before_action :set_category, only: %i[ show ]

  def index
    @categories = current_user.categories
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to categories_path
    else
      render :new, status: :unprocessable_entity
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
