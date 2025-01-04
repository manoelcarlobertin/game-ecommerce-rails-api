require 'rails_helper'

RSpec.describe "Admin V1 Categories", type: :request do
  let(:user) { create(:user) }

  context "GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }

    before do
      get url, headers: auth_header(user)
      puts response.status # Para verificar o status da resposta
      puts response.body   # Para verificar a resposta
      puts categories.inspect # Para verificar as categorias criadas
    end

    it "returns success status 200" do
      expect(response).to have_http_status(:ok)
    end

    it "returns all Categories" do
      body_json = JSON.parse(response.body)
      expect(body_json).to contain_exactly(*categories.as_json(only: %i(id name)))
    end
  end
end
