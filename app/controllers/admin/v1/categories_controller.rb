module Admin::V1
  class CategoriesController < ApiController
    def index
      @categories = Category.all
      render json: @categories.as_json(only: %i(id name))
    end

    def create
      @category = Category.new
      @category.attributes = category_params

     # @category.user = current_user  # if using Devise authentication

      # @category.save

      # if the save is successful, render the created category
      # else, render an error response with the errors from the model object
      # The status code will be 422 (Unprocessable Entity) in this case
      # render json: @category, status: :created
      @category.save!
      render :show
    rescue
      render json: { errors: { fields: @category.errors.messages } }, status: :unprocessable_entity
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
    
    # def update
    # @category = Category.find(params[:id])
    
    # if @category.update(category_params)
    # render json: @category.as_json(only: %i(id name)), status: :ok
    # else
    # render json: @category.errors, status: :unprocessable_entity
    # end
    # end
    
    # def destroy
    # @category = Category.find(params[:id])
    # @category.destroy
    # render json: {}, status: :no_content
    # end

    private

    def category_params
      params.require(:category).permit(:id, :name)
    end
  end
end
