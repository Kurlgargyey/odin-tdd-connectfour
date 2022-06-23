require 'game.rb'

describe Game do
  subject(:game_init) { described_class.new }

  it 'has a board' do
    board = game_init.instance_variable_get(:@board)
    expect(board).not_to eq(nil)
  end

  describe 'the board' do
    subject(:game_board) { described_class.new }
    
    it 'is an array of size cols' do
      board = game_board.instance_variable_get(:@board)
      default_cols = 7
      expect(board.length).to eq(default_cols)
    end

    it 'contains arrays of size rows' do
      board = game_board.instance_variable_get(:@board)
      default_rows = 6
      board.each do |col|
        expect(col.length).to eq(default_rows)
      end
    end

    context 'with 10 cols and 4 rows' do
      cols = 10
      rows = 4
      subject(:game_special_board) { described_class.new(cols, rows) }

      it 'is an array of size 10' do
        board = game_special_board.instance_variable_get(:@board)
        expect(board.length).to eq(10)
      end

      it 'contains array of size 4' do
        board = game_special_board.instance_variable_get(:@board)
        board.each do |col|
          expect(col.length).to eq(4)
        end
      end
    end

    context 'with bad arguments' do
      bad_cols = 'afs'
      bad_rows = nil
      subject(:game_bad_board) { described_class.new(bad_cols, bad_rows) }

      it 'uses default cols' do
        board = game_bad_board.instance_variable_get(:@board)
        expect(board.length).to eql(7)
      end

      it 'uses default rows' do
        board = game_bad_board.instance_variable_get(:@board)
        expect(board).not_to be_empty
        board.each do |col|
          expect(col.length).to eq(6)
        end
      end
    end
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

  describe '#run_game' do
    subject(:game_start) { described_class.new }

    it '' do
      
    end
  end
end