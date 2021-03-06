class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render json: @categories
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    @category = Category.find(params[:id])
    if params[:post_id]
      @post = Post.find(params[:post_id])
      unless @post.categories.include? @category
        @post.categories << @category
      end
      render json: @post.categories, status: :ok
    else
      if @category.update(category_params)
        head :no_content
      else
        render json: @category.errors,status: :unprocessable_entity
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if params[:post_id]
      post = Post.find(params[:post_id])
      post.categories.delete(@category)
      head :no_content
    else
      @category.destroy
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end