module Admin::V1
  class CategoriesController < ApiController
    before_action :load_category, only: [:update, :destroy]

    def index
      @categories = Category.all
      render json: @categories.as_json(only: %i(id name))
    end

    def create
      @category = Category.new
      @category.attributes = category_params

      save_category!
    end
    # def new
    #   @category = Category.new
    # end

    # def edit
    #   @category = Category.find(params[:id])
    # end

    # def search
    # @categories = Category.where("name ILIKE?", "%#{params[:query]}%")
    # render json: @categories.as_json(only: %i(id name))
    # end
    # def show
    #   @category = Category.find(params[:id])
    #   render json: @category.as_json(only: %i(id name))
    # end
    
    def update
      if @category.update(category_params)
        render json: @category.as_json(only: %i(id name)), status: :ok
      else
        render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
      end
    end

  def destroy
    if @category
      @category.destroy!
      render json: {}, status: :no_content
    else
      render_error(fields: { id: ["not found"] }, status: :not_found)
    end
    rescue ActiveRecord::RecordNotDestroyed => e
      render_error(fields: @category.errors.messages, status: :unprocessable_entity)
    end


    private

    def load_category
      @category = Category.find_by(id: params[:id])
    end

    def category_params
      params.require(:category).permit(:id, :name)
    end

    def save_category!
      @category.save!
      render :show
    rescue
      render_error(fields: @category.errors.messages)
    end
  end
end
