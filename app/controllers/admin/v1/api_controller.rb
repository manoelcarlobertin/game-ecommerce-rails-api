module Admin::V1
  class ApiController < ApplicationController
    class ForbiddenAccess < StandardError; end
    include Authenticatable

    include SimpleErrorRenderable
    self.simple_error_partial = "shared/simple_error"

    rescue_from ForbiddenAccess do
      render_error(message: "Forbidden access", status: :forbidden)
    end

    before_action :restrict_access_for_admin!

    private

    def restrict_access_for_admin!
      raise ForbiddenAccess unless current_user.admin?
    end
  end
end


    # def authenticate_admin!
    #   authenticate_or_request_with_http_token do |token, _options|
    #     AdminUser.find_by(api_token: token)
    #   end
    # end