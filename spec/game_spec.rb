require 'game'

describe Game do
  subject(:game_init) { described_class.new }

  it 'has a board' do
    board = game_init.instance_variable_get(:@board)
    expect(board).not_to eq(nil)
  end

  describe 'the board' do
      
    context 'without arguments' do
      subject(:game_board) { described_class.new }
      it 'is an array of size cols' do
        board = game_board.instance_variable_get(:@board)
        default_cols = 7
        expect(board.length).to eq(default_cols)
      end

      it 'contains empty arrays' do
        board = game_board.instance_variable_get(:@board)
        board.each do |col|
          expect(col.length).to eq(0)
        end
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

      it 'contains empty arrays' do
        board = game_special_board.instance_variable_get(:@board)
        board.each do |col|
          expect(col.length).to eq(0)
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

      it 'contains empty arrays' do
        board = game_bad_board.instance_variable_get(:@board)
        expect(board).not_to be_empty
        board.each do |col|
          expect(col.length).to eq(0)
        end
      end
    end
  end

  it 'keeps score in a hash' do
    scores = game_init.instance_variable_get(:@scores)
    expect(scores).to be_a(Hash)
  end

  it 'starts with X active' do
    active_player = game_init.instance_variable_get(:@active_player)
    expect(active_player).to eq('X')
  end

  it 'responds to #run_game' do
    expect(game_init).to respond_to(:run_game)
  end

  describe '#input_move' do
    subject(:game_input) { described_class.new }

    context 'when the input is a valid column number' do
      before do
        allow(game_input).to receive(:gets).and_return('3')
      end

      it 'returns the input' do
        expect(game_input.input_move).to eql(3)
      end
    end

    context 'when there are out-of-bounds inputs' do
      before do
        allow(game_input).to receive(:gets).and_return('10', '11', 'g', '-1', '4', '5')
      end

      it 'calls #gets until it receives a valid input' do
        expect(game_input).to receive(:gets).exactly(5).times
        game_input.input_move
      end

      it 'returns the first valid input' do
        expect(game_input.input_move).to eql(4)
      end
    end
  end

  describe '#make_move' do
    subject(:game_move) { described_class.new }
    selected_col = 4

    context 'when X is active' do
      before do
        game_move.instance_variable_set(:@active_player, 'X')
      end

      context 'when there are no other markers in the column' do
        it 'places an X marker in the first place on the column' do
          game_move.make_move(selected_col)
          expect(game_move.board[selected_col - 1].last).to eq('X')
        end

        it 'returns the coordinates of the executed move' do
          expect(game_move.make_move(selected_col)).to eq([3, 0])
        end
      end

      context 'when the column already has a marker' do
        before do
          game_move.board[selected_col - 1].push('O')
        end

        it 'keeps the previous marker' do
          game_move.make_move(selected_col)
          expect(game_move.board[selected_col - 1].last).to eq('X')
          expect(game_move.board[selected_col - 1][0]).to eq('O')
        end

        it 'returns the coordinates of the executed move' do
          expect(game_move.make_move(selected_col)).to eq([3, 1])
        end
      end

      context 'when the column is already full' do
        before do
          6.times { game_move.board[selected_col - 1].push('O') }
        end

        new_move = 3

        before do
          allow(game_move).to receive(:input_move).and_return(new_move)
        end

        it 'asks for another move' do
          expect(game_move).to receive(:input_move)
          game_move.make_move(selected_col)
        end

        it 'makes the new move' do
          game_move.make_move(selected_col)
          expect(game_move.board[new_move - 1].last).to eq('X')
        end

        it 'does not make the invalid move' do
          expect(game_move.board[selected_col - 1]).not_to receive(:push)
          game_move.make_move(selected_col)
        end

        it 'returns the coordinates of the executed move' do
          expect(game_move.make_move(selected_col)).to eq([2, 0])
        end

        context 'when there is another invalid input' do
          before do
            allow(game_move).to receive(:input_move).and_return(selected_col, new_move)
          end

          it 'asks for another move again' do
            expect(game_move).to receive(:input_move).twice
            game_move.make_move(selected_col)
          end

          it 'makes the new move' do
            game_move.make_move(selected_col)
            expect(game_move.board[new_move - 1].last).to eq('X')
          end

          it 'does not make the invalid move' do
            expect(game_move.board[selected_col - 1]).not_to receive(:push)
            game_move.make_move(selected_col)
          end

          it 'returns the coordinates of the executed move' do
            expect(game_move.make_move(selected_col)).to eq([2, 0])
          end
        end
      end
    end
  end

  describe '#process_turn' do
    subject(:game_turn) { described_class.new }

    before do
      allow(game_turn).to receive(:input_move)
      allow(game_turn).to receive(:make_move)
      allow(game_turn).to receive(:game_over?).and_return(false)
    end

    it 'asks for a move' do
      expect(game_turn).to receive(:input_move)
      game_turn.process_turn
    end

    it 'makes the move' do
      expect(game_turn).to receive(:make_move)
      game_turn.process_turn
    end

    it 'swaps the active player' do
      previous_player = game_turn.instance_variable_get(:@active_player)
      game_turn.process_turn
      expect(game_turn.instance_variable_get(:@active_player)).not_to be(previous_player)
    end

    context 'if the game ends on that turn' do
      before do
        allow(game_turn).to receive(:game_over?).and_return(true)
      end

      it 'does not swap active player' do
        previous_player = game_turn.instance_variable_get(:@active_player)
        game_turn.process_turn
        expect(game_turn.instance_variable_get(:@active_player)).to be(previous_player)
      end
    end
  end

  describe '#game_over?' do
    subject(:game_end) { described_class.new }
    last_move = [3, 3]

    context 'when the board is full' do
      before do
        7.times { |i| 6.times { game_end.board[i].push(nil) } }
      end

      it 'returns true' do
        expect(game_end.game_over?(last_move)).to be true
      end
    end

    context 'when the connect 4 is vertical' do
      before do
        4.times { game_end.board[3].push('O') }
      end

      it 'returns true' do
        expect(game_end.game_over?(last_move)).to be true
      end
    end

    context 'when there is no connect 4' do
      it 'returns false' do
        last_move = [0, 0]
        expect(game_end.game_over?(last_move)).to be false
      end
    end

    context 'when the connect 4 is horizontal' do
      before do
        4.times { |i| game_end.board[i].push('O') }
        last_move = [3, 0]
      end

      it 'returns true' do
        expect(game_end.game_over?(last_move)).to be true
      end
    end

    context 'when the connect 4 is diagonal' do
      before do
        4.times { |i| i.times { game_end.board[i].push('X') } }
        4.times { |i| game_end.board[i].push('O') }
        last_move = [3, 3]
      end

      it 'returns true' do
        expect(game_end.game_over?(last_move)).to be true
      end
    end

    context 'when the connect 4 is diagonal reversed' do
      before do
        4.times { |i| 3 - i.times { game_end.board[i].push('X') } }
        4.times { |i| game_end.board[i].push('O') }
        last_move = [3, 0]
      end

      it 'returns true' do
        expect(game_end.game_over?(last_move)).to be true
      end
    end
  end
end
