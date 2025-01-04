module Admin::V1
  class CategoriesController < ApiController
    def index
      @categories = Category.all
      render json: @categories.as_json(only: %i(id name))
    end
  end
end
