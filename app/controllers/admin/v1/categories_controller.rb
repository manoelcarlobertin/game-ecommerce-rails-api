module Admin::V1
  class CategoriesController < ApiController
    def index
      @categories = Category.all
      render json: @categories.as_json(only: %i(id name))
    end

    def create
      @category = Category.new
      @category.attributes = category_params

      @category.save!
      render :show # criar a view *show* do **Jbuilder** para renderizar a categoria
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
