require 'rails_helper'

RSpec.describe "Admin V1 Categories as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }

    before do
      get url, headers: auth_header(user)
      # puts response.status # Para verificar o status da resposta
      # puts response.body   # Para verificar a resposta
      # puts categories.inspect # Para verificar as categorias criadas
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

  # context "PATCH /categories/:id" do
  #   let!(:category) { create(:category) }
  #   let(:url) { "/admin/v1/categories/#{category.id}" }
  #   let(:valid_attributes) { { name: "Updated Name", description: "Updated Description" } }
  #   let(:invalid_attributes) { { name: "", description: "Updated Description" } }

  #   describe "with valid parameters" do
  #     it "updates the category attributes in the database" do
  #       patch url,
  #           headers: auth_header(user).merge({ "Content-Type" => "application/json" }),
  #           params: valid_attributes.to_json

  #       category.reload
  #       expect(category.name).to eq(valid_attributes[:name])
  #       expect(category.id).to eq(valid_attributes[:description])
  #     end

  #     it "returns status code 200" do
  #         patch url,
  #           headers: auth_header(user).merge({ "Content-Type" => "application/json" }),
  #           params: valid_attributes.to_json

  #       expect(response).to have_http_status(:ok)
  #     end

  #     it "returns the updated category in the response body" do
  #       patch url,
  #           headers: auth_header(user).merge({ "Content-Type" => "application/json" }),
  #           params: valid_attributes.to_json

  #       expect(response.body).to include(valid_attributes[:name])
  #       expect(response.body).to include(valid_attributes[:description])
  #     end

  #     it "does not update the category in the database" do
  #       original_name = category.name

  #       patch url,
  #           headers: auth_header(user).merge({ "Content-Type" => "application/json" }),
  #           params: valid_attributes.to_json

  #       category.reload
  #       expect(category.name).to eq(original_name)
  #     end

  #     it "returns status code 422 (Unprocessable Entity)" do
  #       patch url,
  #           headers: auth_header(user).merge({ "Content-Type" => "application/json" }),
  #           params: valid_attributes.to_json

  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end

  #     it "returns error messages in the response body" do
  #       patch url, headers: auth_header(user), params: invalid_attributes

  #       expect(response.body).to include("can't be blank")
  #     end
  #   end
  # end

  

  context "DELETE /categories/:id" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    it 'removes Category' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Category, :count).by(-1)
    end

    it 'returns success status 204' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end

    it 'removes all associated product categories' do
      product_categories = create_list(:product_category, 3, category: category)
      delete url, headers: auth_header(user)
      expected_product_categories = ProductCategory.where(id: product_categories.map(&:id))
      expect(expected_product_categories.count).to eq 0
    end

    it 'does not remove unassociated product categories' do
      product_categories = create_list(:product_category, 3)
      delete url, headers: auth_header(user)
      present_product_categories_ids = product_categories.map(&:id)
      expected_product_categories = ProductCategory.where(id: present_product_categories_ids)
      expect(expected_product_categories.ids).to contain_exactly(*present_product_categories_ids)
    end
  end
end
