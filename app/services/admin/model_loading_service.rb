module Admin
  class ModelLoadingService
    attr_reader :records, :pagination

    def initialize(searchable_model, params = {})
      @searchable_model = searchable_model
      @params = params || {}
      @records = []
      @pagination = {}
    end

    def call
      set_pagination_values
      searched = @searchable_model.search_by_name(@params.dig(:search, :name))
      @records = searched.order(@params[:order].to_h)
                   .paginate(@params[:page], @params[:length])
      set_pagination_attributes(searched.count)
    end

    private

    def set_pagination_attributes(total_filtered)
      total_pages = (total_filtered / @params[:length].to_f).ceil
      @pagination.merge!(page: @params[:page], length: @records.count, 
                         total: total_filtered, total_pages: total_pages)
    end
  end
end