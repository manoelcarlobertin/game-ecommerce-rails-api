module Auth
  module V1
    class SessionsController < Devise::SessionsController
      def create
        render json: { message: 'Sessão criada com sucesso!' }, status: :ok
      end
    end
  end
end
