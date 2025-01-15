module Admin::V1
  class CategoriesController < ApiController
    before_action :load_category, only: [:show, :update, :destroy]

    def index # instanciar o service
      @loading_service = Admin::ModelLoadingService.new(Category.all, searchable_params)
      @loading_service.call #  e chamar o call
    end

    def create
      @category = Category.new
      @category.attributes = category_params

      save_category!
    end

    def show; end

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
        render json: @category.as_json(only: %i[id name]), status: :ok
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

    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
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
