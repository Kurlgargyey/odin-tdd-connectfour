class Game
  attr_accessor :board

  def initialize(cols = 7, rows = 6)
    @cols = cols.to_i.positive? ? cols.to_i : 7
    @rows = rows.to_i.positive? ? rows.to_i : 6
    @board = Array.new(@cols) { Array.new() }
    @scores = Hash.new(0)
    @players = %w[X O]
    @active_player = @players[0]
    @last_move = []
  end

  def run_game

  end

  def process_turn
    move = input_move
    make_move(move)
    return if game_over?(move)

    @active_player = @players.rotate![0]
  end

  def input_move
    move = -1
    move = gets.chomp.to_i until move_valid?(move)
    move
  end

  def make_move(col)
    return board[col - 1].push(@active_player) unless col_full?(col)

    new_move = input_move
    make_move(new_move)
  end

  def game_over?(move)
    return true if board_full?
    #return true if connect_four?
  end

  def board_full?
    board.all? { |col| col.length == @rows }
  end

  def col_full?(col)
    board[col - 1].length == @rows
  end

  def move_valid?(move)
    move.between?(1, @cols)
  end
end
