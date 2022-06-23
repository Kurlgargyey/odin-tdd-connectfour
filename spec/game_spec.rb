require 'game.rb'

describe Game do
  subject(:game_init) { described_class.new }

  it 'has a board' do
    board = game_init.instance_variable_get(:@board)
    expect(board).not_to eq(nil)
  end

  it 'keeps score in a hash' do
    scores = game_init.instance_variable_get(:@scores)
    expect(scores).to be_a(Hash)
  end

  it 'starts with Player 1' do
    active_player = game_init.instance_variable_get(:@active_player)
    expect(active_player).to eq(1)
  end

  it 'responds to #run_game' do
    expect(game_init).to respond_to(:run_game)
  end

  describe '#game_over?' do

  end
end