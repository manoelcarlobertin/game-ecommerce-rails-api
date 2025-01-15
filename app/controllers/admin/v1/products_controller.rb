module Admin::V1
  class ProductsController < ApiController
    before_action :load_product, only: [:show,:update, :destroy]

    def index
      @loading_service = Admin::ModelLoadingService.new(Product.all, searchable_params)
      @loading_service.call
    end

    def create
      run_service
    rescue Admin::ProductSavingService::NotSavedProductError
      render_error(fields: @saving_service.errors)
    end

    def show; end

    def update
      run_service
    rescue Admin::ProductSavingService::NotSavedProductError
      render_error(fields: @saving_service.errors)
    end

    def destroy
      @product.productable.destroy!
      @product.destroy!
    rescue ActiveRecord::RecordNotDestroyed
      render_error(fields: @product.errors.messages.merge(@product.productable.errors.messages))
    end

    private

    def product_params
      return {} unless params.has_key?(:product)
      permitted_params = params.require(:product).permit(:id, :name, :description, :image,
                                                         :price, :productable,
                                                         :status, category_ids: [])
      permitted_params.merge(productable_params)
    end

    def productable_params
      productable_type = params[:product][:productable] || @product&.productable_type&.underscore
      return unless productable_type.present?
      send("#{productable_type}_params")
    end

    def game_params
      params.require(:product).permit(:mode, :release_date, :developer, :system_requirement_id)
    end

    # instanciando o service
    def run_service(product = nil)
      @saving_service = Admin::ProductSavingService.new(product_params.to_h, @product)
      @saving_service.call
      @product = @saving_service.product
      render :show # vamos preencher com as *partials* na view show
    end

    def load_product
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Product not found' }, status: :not_found
    end

    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end
  end
end
# Com os testes 3 métodos, o *product_params* vai retornar esta estrutura

# ```ruby
# {
#   product: {
#     name: "Name",
#     ...
#     productable: "game",
#     productable_attributes: {
#       mode: "pvp"
#       ...
#     }
#   }
# }