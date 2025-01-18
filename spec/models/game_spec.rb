require 'rails_helper'

RSpec.describe Game, type: :model do
  # Validações e enum
  it { is_expected.to validate_presence_of(:mode) }
  it { is_expected.to define_enum_for(:mode).with_values(pvp: 1, pve: 2, both: 3) }
  it { is_expected.to validate_presence_of(:release_date) }
  it { is_expected.to validate_presence_of(:developer) }

  # Associações
  it { is_expected.to belong_to(:system_requirement) }
  it { is_expected.to have_one(:product) }

  # Criação de um jogo de exemplo com let
  let(:game) do
    Game.create!(
      name: "Test Game",
      mode: "pvp",
      release_date: "2024-12-11",
      developer: "Test",
      system_requirement: create(:system_requirement)
    )
  end

  # Teste para a pesquisa
  context 'when searching for a game' do
    it 'returns results matching the search query' do
      result = Game.search("Test Game")
      expect(result).to include(game)
    end
  end

  # Teste para o comportamento de pesquisa (searchable concern)
  it_behaves_like "like searchable concern", :game, :name
end
