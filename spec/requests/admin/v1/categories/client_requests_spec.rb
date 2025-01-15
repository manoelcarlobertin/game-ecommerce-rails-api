require 'rails_helper'

RSpec.describe "Admin V1 Categories as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }
  end

  context "POST /categories" do
    let(:url) { "/admin/v1/categories" }
  end

  context "PATCH /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }
  end

  context "DELETE /categories/:id" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }
  end

end