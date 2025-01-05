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

  context "POST /categories" do
    let(:url) { "/admin/v1/categories" }

    context "with valid params" do
      let(:category_params) { { category: attributes_for(:category) }.to_json }

      it 'adds a new Category' do
        expect do
          post url, headers: auth_header(user), params: category_params
        end.to change(Category, :count).by(1)
      end

      # it "returns the created Category" do
      #   post url, headers: auth_header(user), params: category_params
      #   body_json = JSON.parse(response.body)

      #   expect(body_json).to include("id", "name")
      #   expect(body_json['category']['name']).to eq(attributes_for(:category)[:name])
      #   expect(body_json['category']['id']).not_to be_nil
      #   expect(body_json['category']['id']).to be_a(Integer)
      #   expect(body_json['category']['id']).to be > 0
      #   expect(body_json['category']['name']).not_to be_empty
      #   expect(body_json['category']['id']).not_to be_blank
      #   expect(body_json['category']['name']).not_to be_nil
      #   expect(body_json['category']['id']).not_to be_blank
      # end

      it "returns success status 200" do
        post url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:ok)
      end

      it 'returns last added Category' do
        post url, headers: auth_header(user), params: category_params
        expected_category = Category.last.as_json(only: %i(id name))
        expect(body_json['category']).to eq expected_category
      end
    end

    context "with invalid params" do
      let(:category_invalid_params) do
        { category: attributes_for(:category, name: nil) }.to_json
      end

      it 'does not add a new Category' do
        expect do
          post url, headers: auth_header(user), params: category_invalid_params
        end.to_not change(Category, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
       end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
